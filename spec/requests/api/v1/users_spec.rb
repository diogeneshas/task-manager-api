require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      "Accept" => "application/vnd.taskmanager.v1",
      "Content-Type" => Mime[:json].to_s
    }
  end

  before { host! "api.task-manager.test" }

  describe "Get users/:id" do
    before do
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context "when the user exists" do
      it "returns the user" do
        user_response = JSON.parse(response.body)
        expect(user_response["id"]).to eq(user_id)
      end

      it "return status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the users do not exist" do
      let(:user_id) { 300 }
      it "return status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "Post /users" do
    before do
      post "/users", params: { user: user_params }.to_json, headers: headers
    end

    context "when the request params are valid" do
      let(:user_params) { attributes_for(:user) }

      it "returns state code 201" do
        expect(response).to have_http_status(201)
      end

      it "return json data for the created user" do
        user_response = JSON.parse(response.body)
        expect(user_response["email"]).to eq(user_params[:email])
      end
    end

    context "when the request params are invalid" do
      let(:user_params) { attributes_for(:user, email: 'invalid_email@')}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        user_response = JSON.parse(response.body)
        expect(user_response).to have_key('errors')
      end
    end
  end

  describe "PUT /users/:id" do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context "when the request params are valid" do
      let(:user_params) { { email: 'new@email.com' } }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the json data for the updated user" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(user_params[:email])
      end
    end

    context "when the request params are invalid" do
      let(:user_params) { { email: 'invalid_email@' } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
    end
  end

  describe "DELETE /users/:id" do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect( User.find_by(id: user.id) ).to be_nil
    end
  end
end
