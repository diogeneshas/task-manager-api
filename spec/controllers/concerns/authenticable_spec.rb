require 'rails_helper'

Rspec.describe Authenticable do
  controller(ApplicationController) do
  include Authenticable
  end

  let(:app_controller) { subject }

    describe "#current_user" do
      let(:user) { create(:user)}

      before do
        req = double(:headers => { 'Authorization' => user.auth_token } )
        allow(app_controller).to receive(:request).and_return(req)
      end

      it "return the users from the authorization header" do
        expect(app_controller.current_user).to eq(user)
      end
    end
  end
