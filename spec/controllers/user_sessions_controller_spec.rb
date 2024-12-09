require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, password: 'password') }

    context 'when login is successful' do
      it 'logs in the user and redirects to diaries path' do
        post :create, params: { email: user.email, password: 'password' }
        expect(controller.current_user).to eq(user)
        expect(response).to redirect_to(diaries_path)
        expect(flash[:success]).to eq(I18n.t('user_sessions.create.success'))
      end
    end

    context 'when login fails' do
      it 're-renders the new template with error message' do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        expect(controller.current_user).to be_nil
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:danger]).to eq(I18n.t('user_sessions.create.failure'))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

    before do
      login_user(user)
    end

    it 'logs out the user and redirects to root path' do
      delete :destroy
      expect(controller.current_user).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:success]).to eq(I18n.t('user_sessions.destroy.success'))
    end
  end
end
