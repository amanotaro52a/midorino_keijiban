require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(user) # current_userをモック
  end

  describe "GET #edit" do
    it "assigns the current user to @user" do
      get :edit
      expect(assigns(:user)).to eq(user)
    end

    it "renders the edit template" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      let(:valid_attributes) { { email: 'new_email@example.com', name: 'New Name' } }

      it "updates the user" do
        put :update, params: { user: valid_attributes }
        user.reload
        expect(user.email).to eq('new_email@example.com')
        expect(user.name).to eq('New Name')
      end

      it "redirects to profile path with a success message" do
        put :update, params: { user: valid_attributes }
        expect(response).to redirect_to(profile_path)
        expect(flash[:success]).to eq(I18n.t('defaults.flash_message.updated', item: User.model_name.human))
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { { email: '' } }

      it "does not update the user" do
        put :update, params: { user: invalid_attributes }
        user.reload
        expect(user.email).not_to eq('')
      end

      it "re-renders the edit template with a danger message" do
        put :update, params: { user: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:danger]).to eq(I18n.t('defaults.flash_message.not_updated', item: User.model_name.human))
      end
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show
      expect(response).to render_template(:show)
    end
  end
end
