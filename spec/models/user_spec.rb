require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of(:password) }
  it { should allow_value("diogenes@gmail.com").for(:email) }
end
