require "rails_helper"

RSpec.describe "Task API", type: :request do
  before { host! "api.task-manager.test" }

  let!(:user) { create(:user) }
  let(:headers) do
    {
      "Accept" => "application/vnd.taskmanager.v1",
      "Content-Type" => Mime[:json].to_s
    }
  end

  describe "GET /api/tasks" do
    before do
      create_list(:task, 5, user_id: user.id)
      get "/tasks", params: {}, headers: headers
    end

    it " returns status 200" do
      expect(response).to have_http_status(200)
    end

    it "returns all tasks" do
      expect(json_body[:tasks].count).to eq(5)
    end
  end

  describe "GET /tasks/:id" do
    let(:task) { create(:task, user_id: user.id) }

    before { get "/tasks/#{task.id}", params: {}, headers: headers }

    it "returns status 200" do
      expect(response).to have_http_status(200)
    end

    it "returns the json for task" do
      expect(json_body[:title]).to eq(task.title)
    end
  end

  describe "POST /tasks" do
    before do
      post "/tasks", params: { task: task_params }.to_json, headers: headers
    end

    context "when the params are valid" do
      let(:tasks_params) { attributes_for(tasks) }

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end

      it "saves the task int the database" do
        expect(Task.find(title: task_params[:title])).not_to be_nil
      end

      it "return the json for created task" do
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it "assigns the created task to the currrent user" do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    context "when the params are invalid" do
      let(:task_params) { attributes_for(:task, title: "") }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "does not save the task in the database" do
        expect(Taks.find_by(title: task_params[:title])).to be_nil
      end

      it "returns the json error for title" do
        expect(json_body[:errors]).to have_key(:title)
      end
    end
  end

  describe "PUT /tasks/:id" do
    let!(:task) { create(:task, user_id: user.id) }
    before do
      put "/tasks/#{task.id}",
          params: { task: task_params }.to_json,
          headers: headers
    end

    context "when the params are valid" do
      let(:task_params) { { title: "New Task" } }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json for updated task" do
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it "updates the task in the database" do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end
    end

    context "when the params are invalid" do
      let(:task_params) { { title: " " } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns the json error for title" do
        expect(json_body[:errors]).to have_key(:title)
      end

      it "does not update the task in the database" do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end
    end
  end

  describe "DELETE /tasks/:id" do
    let!(:task) { create(:task, user_id: user.id) }
    before { delete "/tasks/#{task.id}", params: {}, headers: headers }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end

    it "deletes the task from the database" do
      expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Task.find_by(id: task.id)).to be_nil
    end
  end

end
