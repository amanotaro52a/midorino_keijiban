require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe "GET /" do
    it "一覧ページが正常に表示される" do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(assigns(:posts)).to be_present
    end
  end
end
