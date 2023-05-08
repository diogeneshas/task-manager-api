require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of(:password) }
  it { should allow_value("diogenes@gmail.com").for(:email) }
  it { should validate_uniqueness_of(:auth_token) }

  describe "#info" do
    it "returns email, created_at and a Token" do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return("abc123xyzTOKEN")

      expect(user.info).to eq(
        "#{user.email} - #{user.created_at} - Token: abc123xyzTOKEN"
      )
    end
  end

  describe "#generate_authentication_token!" do
    it "generate a unique auth token" do
      allow(Devise).to receive(:friendly_token).and_return("abc123xyzTOKEN")
      user.generate_authentication_token!

      expect(user.auth_token).to eq("abc123xyzTOKEN")
    end

    it "generates another auth token when the current auth token already has been taken" do
      allow(Devise).to receive(:friendly_token).and_return(
        "abc123xyztoken",
        "abc123xyzTOKENFOURTH",
        "abcXYZ123456789"
      )
      existing_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end
  end
end
