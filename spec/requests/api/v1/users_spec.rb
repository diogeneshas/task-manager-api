require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }

  before { host! "api.task-manager.test" }

  describe "Get users/:id" do
    before do
      headers = { "Accept" => "application/vnd.taskmanager.v1" }
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
end
