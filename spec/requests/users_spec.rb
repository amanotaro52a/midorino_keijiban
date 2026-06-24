require 'rails_helper'

# 変更前は type: :model で書かれており request spec として機能していなかった。
# バリデーション・アソシエーションのテストは spec/models/user_spec.rb に統合し、
# このファイルは HTTP リクエスト・レスポンスの確認に専念する。
RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    context "未ログインの場合" do
      it "200 OK を返すこと" do
        get new_user_path
        expect(response).to have_http_status(:ok)
      end

      it "登録フォームが表示されること" do
        get new_user_path
        expect(response.body).to include('form')
      end
    end

    # ログイン済みユーザーが /users/new にアクセスした場合のリダイレクトは
    # アプリ側に実装がないため省略
  end

  describe "POST /users" do
    context "有効なパラメータの場合" do
      let(:valid_params) do
        {
          user: {
            name: "New User",
            email: "newuser@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "ユーザーが作成されること" do
        expect {
          post users_path, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "ルートページへリダイレクトすること" do
        post users_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        post users_path, params: valid_params
        expect(flash[:success]).to eq(I18n.t('users.create.success'))
      end

      it "登録後にログイン状態になること" do
        post users_path, params: valid_params
        expect(session[:user_id]).to be_present
      end
    end

    context "無効なパラメータの場合（名前が空）" do
      let(:invalid_params) do
        {
          user: {
            name: "",
            email: "newuser@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "ユーザーが作成されないこと" do
        expect {
          post users_path, params: invalid_params
        }.not_to change(User, :count)
      end

      it "登録フォームが再表示されること" do
        post users_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "エラーのフラッシュメッセージが表示されること" do
        post users_path, params: invalid_params
        expect(flash[:danger]).to eq(I18n.t('users.create.failure'))
      end
    end

    context "無効なパラメータの場合（メールアドレスが重複）" do
      let!(:existing_user) { create(:user, email: "duplicate@example.com") }
      let(:duplicate_params) do
        {
          user: {
            name: "Another User",
            email: "duplicate@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "ユーザーが作成されないこと" do
        expect {
          post users_path, params: duplicate_params
        }.not_to change(User, :count)
      end

      it "登録フォームが再表示されること" do
        post users_path, params: duplicate_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "無効なパラメータの場合（パスワード不一致）" do
      let(:mismatch_params) do
        {
          user: {
            name: "New User",
            email: "newuser@example.com",
            password: "password",
            password_confirmation: "wrong"
          }
        }
      end

      it "ユーザーが作成されないこと" do
        expect {
          post users_path, params: mismatch_params
        }.not_to change(User, :count)
      end
    end
  end
end
