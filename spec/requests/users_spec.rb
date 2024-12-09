require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    subject { FactoryBot.build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(3).on(:create) }
    it { should validate_confirmation_of(:password).on(:create) }
    it { should validate_presence_of(:password_confirmation).on(:create) }

    it "allows reset_password_token to be nil" do
      user = FactoryBot.build(:user, reset_password_token: nil)
      expect(user).to be_valid
    end

    it "requires reset_password_token to be unique" do
      existing_user = FactoryBot.create(:user, reset_password_token: "unique_token")
      new_user = FactoryBot.build(:user, reset_password_token: "unique_token")
      expect(new_user).not_to be_valid
      expect(new_user.errors[:reset_password_token]).to include("はすでに存在します")
    end
  end

  describe "associations" do
    it { should have_many(:diaries).dependent(:destroy) }
  end

  describe "#deliver_reset_password_instructions!" do
    let(:user) { FactoryBot.create(:user) }

    it "calls Sorcery's reset password instructions method" do
      expect(user).to receive(:deliver_reset_password_instructions!).and_call_original
      user.deliver_reset_password_instructions!
    end

    it "sends a reset password email" do
      expect {
        user.deliver_reset_password_instructions!
      }.to have_enqueued_mail(UserMailer, :reset_password_email).with(user)
    end
  end
end
