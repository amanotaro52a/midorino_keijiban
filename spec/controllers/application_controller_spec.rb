require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index
      render plain: "OK"
    end
  end

  # 変更前は before_action :require_login と #not_authenticated の2つの describe で
  # 同一ケース（未ログイン時のリダイレクト）を重複テストしていた。
  # 1つの describe に統合し、ログイン済み時の正常アクセスケースを追加している。

  describe "before_action :require_login" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get :index
        expect(response).to redirect_to(login_path)
      end

      it "danger フラッシュメッセージが表示されること" do
        get :index
        expect(flash[:danger]).to eq(I18n.t('defaults.flash_message.require_login'))
      end
    end

    context "ログイン済みの場合" do
      let(:user) { create(:user) }

      before { login_user(user) }

      it "正常にアクセスできること" do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it "ログインページへリダイレクトされないこと" do
        get :index
        expect(response).not_to redirect_to(login_path)
      end
    end
  end
end
