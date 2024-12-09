require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "when the email exists" do
      it "sends reset password instructions and redirects to login path" do
        expect_any_instance_of(User).to receive(:deliver_reset_password_instructions!)
        post :create, params: { email: user.email }
        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to eq(I18n.t('password_resets.create.success'))
      end
    end

    context "when the email does not exist" do
      it "still redirects to login path with a success message" do
        post :create, params: { email: 'nonexistent@example.com' }
        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to eq(I18n.t('password_resets.create.success'))
      end
    end
  end

  describe "GET #edit" do
    context "with a valid token" do
      it "renders the edit template" do
        user.deliver_reset_password_instructions!
        get :edit, params: { id: user.reset_password_token }
        expect(response).to render_template(:edit)
      end
    end

    context "with an invalid token" do
      it "redirects to not_authenticated page" do
        get :edit, params: { id: 'invalid-token' }
        expect(response).to redirect_to(login_path) # 修正
      end
    end
  end

  describe "PATCH #update" do
    context "with a valid token and matching passwords" do
      it "changes the password and redirects to login path" do
        user.deliver_reset_password_instructions!
        patch :update, params: { id: user.reset_password_token, user: { password: 'newpassword', password_confirmation: 'newpassword' } }
        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to eq(I18n.t('password_resets.update.success'))
      end
    end

    context "with a valid token but mismatching passwords" do
      it "does not change the password and re-renders the edit template" do
        user.deliver_reset_password_instructions!
        patch :update, params: { id: user.reset_password_token, user: { password: 'newpassword', password_confirmation: 'wrongconfirmation' } }
        expect(response).to render_template(:edit)
      end
    end

    context "with an invalid token" do
      it "redirects to not_authenticated page" do
        patch :update, params: { id: 'invalid-token', user: { password: 'newpassword', password_confirmation: 'newpassword' } }
        expect(response).to redirect_to(login_path) # 修正
      end
    end
  end
end

