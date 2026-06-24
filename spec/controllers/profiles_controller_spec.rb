require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }

  # 変更前は全テストで current_user をモックしていたため
  # before_action :require_login が実質スキップされており
  # 未ログイン時のリダイレクトが一切テストされていなかった。
  # login_user ヘルパーを使った実認証フローに切り替えている。

  # ----------------------------------------
  # GET #show
  # ----------------------------------------
  describe "GET #show" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get :show
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合" do
      before { login_user(user) }

      it "200 OK を返すこと" do
        get :show
        expect(response).to have_http_status(:ok)
      end

      it ":show テンプレートを描画すること" do
        get :show
        expect(response).to render_template(:show)
      end
    end
  end

  # ----------------------------------------
  # GET #edit
  # ----------------------------------------
  describe "GET #edit" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get :edit
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログイン済みの場合" do
      before { login_user(user) }

      it ":edit テンプレートを描画すること" do
        get :edit
        expect(response).to render_template(:edit)
      end

      it "@user にログインユーザーが格納されること" do
        get :edit
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  # ----------------------------------------
  # PUT #update
  # ----------------------------------------
  describe "PUT #update" do
    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        put :update, params: { user: { name: "New Name" } }
        expect(response).to redirect_to(login_path)
      end

      it "ユーザー情報が更新されないこと" do
        put :update, params: { user: { name: "New Name" } }
        expect(user.reload.name).not_to eq("New Name")
      end
    end

    context "ログイン済みの場合（有効な属性）" do
      before { login_user(user) }

      let(:valid_attributes) { { name: "New Name", email: "new_email@example.com" } }

      it "name が更新されること" do
        put :update, params: { user: valid_attributes }
        expect(user.reload.name).to eq("New Name")
      end

      it "email が更新されること" do
        put :update, params: { user: valid_attributes }
        expect(user.reload.email).to eq("new_email@example.com")
      end

      it "プロフィールページへリダイレクトすること" do
        put :update, params: { user: valid_attributes }
        expect(response).to redirect_to(profile_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        put :update, params: { user: valid_attributes }
        expect(flash[:success]).to eq(I18n.t('defaults.flash_message.updated', item: User.model_name.human))
      end
    end

    # パスワード変更を profiles#update で許可している場合は有効化する
    # Strong Parameters に :password / :password_confirmation が含まれているか要確認
    # context "ログイン済みの場合（パスワード変更）" do
    #   before { login_user(user) }
    #
    #   let(:password_attributes) do
    #     {
    #       password: "newpassword",
    #       password_confirmation: "newpassword"
    #     }
    #   end
    #
    #   it "パスワードが変更されること" do
    #     old_crypted_password = user.crypted_password
    #     put :update, params: { user: password_attributes }
    #     expect(user.reload.crypted_password).not_to eq(old_crypted_password)
    #   end
    #
    #   it "プロフィールページへリダイレクトすること" do
    #     put :update, params: { user: password_attributes }
    #     expect(response).to redirect_to(profile_path)
    #   end
    # end

    context "ログイン済みの場合（無効な属性）" do
      before { login_user(user) }

      let(:invalid_attributes) { { email: "" } }

      it "ユーザー情報が更新されないこと" do
        put :update, params: { user: invalid_attributes }
        expect(user.reload.email).not_to eq("")
      end

      it ":edit テンプレートを再描画すること" do
        put :update, params: { user: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it "422 を返すこと" do
        put :update, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "エラーのフラッシュメッセージが表示されること" do
        put :update, params: { user: invalid_attributes }
        expect(flash[:danger]).to eq(I18n.t('defaults.flash_message.not_updated', item: User.model_name.human))
      end
    end
  end
end
