require 'rails_helper'

RSpec.describe DiariesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:diary) { create(:diary, user: user) }

  describe 'GET #index' do
    it 'renders the index template and assigns @diaries' do
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:diaries)).to eq([diary])
    end
  end

  describe 'GET #new' do
    context 'when logged in' do
      before { login_user(user) }

      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
        expect(assigns(:diary)).to be_a_new(Diary)
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
