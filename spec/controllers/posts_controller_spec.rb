require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe 'GET #new' do
    context 'when logged in' do
      before { login_user(user) }

      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context 'when not logged in' do
      it 'redirects to the login page' do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
