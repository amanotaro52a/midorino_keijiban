require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    { name: 'Test User', email: 'testuser@example.com', password: 'password', password_confirmation: 'password' }
  end

  let(:invalid_attributes) do
    { name: '', email: 'invalidemail', password: 'short', password_confirmation: 'mismatch' }
  end

  describe 'GET #new' do
    it 'assigns a new user to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it 'sets a success flash message' do
        post :create, params: { user: valid_attributes }
        expect(flash[:success]).to eq(I18n.t('users.create.success'))
      end

      it 'logs in the user after creation' do
        post :create, params: { user: valid_attributes }
        expect(controller.current_user).to eq(User.last)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it 'renders the :new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'sets a danger flash message' do
        post :create, params: { user: invalid_attributes }
        expect(flash.now[:danger]).to eq(I18n.t('users.create.failure'))
      end
    end
  end
end
