require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    # 本番の ApplicationController を模倣するアクションを定義
    def index
      render plain: "OK"
    end
  end

  describe "before_action :require_login" do
    context "when not authenticated" do
      it "redirects to the login page with a flash message" do
        # ログインしていない状態でアクセス
        get :index
        expect(response).to redirect_to(login_path)
        expect(flash[:danger]).to eq I18n.t('defaults.flash_message.require_login')
      end
    end
  end

  describe "#not_authenticated" do
    it "redirects to the login path and sets a flash danger message" do
      # `not_authenticated` を直接呼び出してリダイレクトとフラッシュメッセージを確認
      get :index
      expect(response).to redirect_to(login_path)
      expect(flash[:danger]).to eq I18n.t('defaults.flash_message.require_login')
    end
  end
end
