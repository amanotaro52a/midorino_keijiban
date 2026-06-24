require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { create(:user) }

  # ----------------------------------------
  # GET #new
  # ----------------------------------------
  describe "GET #new" do
    context "未ログインの場合" do
      it ":new テンプレートを描画すること" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    # アプリ側に「ログイン済みならリダイレクト」の実装がある場合は有効化する
    # context "ログイン済みの場合" do
    #   before { login_user(user) }
    #
    #   it "ルートページへリダイレクトすること" do
    #     get :new
    #     expect(response).to redirect_to(root_path)
    #   end
    # end
  end

  # ----------------------------------------
  # POST #create
  # ----------------------------------------
  describe "POST #create" do
    context "登録済みメールアドレスの場合" do
      it "パスワードリセット手順メールを送信すること" do
        expect_any_instance_of(User).to receive(:deliver_reset_password_instructions!)
        post :create, params: { email: user.email }
      end

      it "ログインページへリダイレクトすること" do
        post :create, params: { email: user.email }
        expect(response).to redirect_to(login_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        post :create, params: { email: user.email }
        expect(flash[:success]).to eq(I18n.t('password_resets.create.success'))
      end
    end

    context "未登録のメールアドレスの場合" do
      # セキュリティ上、メールアドレスの存在有無を外部に漏らさないため
      # 存在しないメールでも同じレスポンスを返す仕様
      it "ログインページへリダイレクトすること" do
        post :create, params: { email: 'nonexistent@example.com' }
        expect(response).to redirect_to(login_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        post :create, params: { email: 'nonexistent@example.com' }
        expect(flash[:success]).to eq(I18n.t('password_resets.create.success'))
      end
    end
  end

  # ----------------------------------------
  # GET #edit
  # ----------------------------------------
  describe "GET #edit" do
    context "有効なトークンの場合" do
      before { user.deliver_reset_password_instructions! }

      it ":edit テンプレートを描画すること" do
        get :edit, params: { id: user.reset_password_token }
        expect(response).to render_template(:edit)
      end
    end

    context "無効なトークンの場合" do
      it "ログインページへリダイレクトすること" do
        get :edit, params: { id: 'invalid-token' }
        expect(response).to redirect_to(login_path)
      end
    end

    # 追加: トークン期限切れのケース
    context "期限切れのトークンの場合" do
      before do
        user.deliver_reset_password_instructions!
        # reset_password_token の有効期限を過去に設定して期限切れを再現する
        user.update_columns(reset_password_token_expires_at: 1.hour.ago)
      end

      it "ログインページへリダイレクトすること" do
        get :edit, params: { id: user.reset_password_token }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  # ----------------------------------------
  # PATCH #update
  # ----------------------------------------
  describe "PATCH #update" do
    context "有効なトークン・パスワードが一致する場合" do
      before { user.deliver_reset_password_instructions! }

      it "ログインページへリダイレクトすること" do
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(response).to redirect_to(login_path)
      end

      it "成功のフラッシュメッセージが表示されること" do
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(flash[:success]).to eq(I18n.t('password_resets.update.success'))
      end

      # 追加: パスワードが実際に変更されているか確認
      it "パスワードが変更されること" do
        old_crypted_password = user.crypted_password
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(user.reload.crypted_password).not_to eq(old_crypted_password)
      end

      # 追加: パスワード変更後にトークンが無効化されているか確認
      it "リセットトークンが無効化されること" do
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(user.reload.reset_password_token).to be_nil
      end
    end

    context "有効なトークン・パスワードが不一致の場合" do
      before { user.deliver_reset_password_instructions! }

      it ":edit テンプレートを再描画すること" do
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'wrongconfirmation' }
        }
        expect(response).to render_template(:edit)
      end

      # 追加: パスワードが変更されていないことを確認
      it "パスワードが変更されないこと" do
        old_crypted_password = user.crypted_password
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'wrongconfirmation' }
        }
        expect(user.reload.crypted_password).to eq(old_crypted_password)
      end
    end

    context "無効なトークンの場合" do
      it "ログインページへリダイレクトすること" do
        patch :update, params: {
          id: 'invalid-token',
          user: { password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(response).to redirect_to(login_path)
      end
    end

    # 追加: トークン期限切れのケース
    context "期限切れのトークンの場合" do
      before do
        user.deliver_reset_password_instructions!
        user.update_columns(reset_password_token_expires_at: 1.hour.ago)
      end

      it "ログインページへリダイレクトすること" do
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(response).to redirect_to(login_path)
      end

      it "パスワードが変更されないこと" do
        old_crypted_password = user.crypted_password
        patch :update, params: {
          id: user.reset_password_token,
          user: { password: 'newpassword', password_confirmation: 'newpassword' }
        }
        expect(user.reload.crypted_password).to eq(old_crypted_password)
      end
    end
  end
end
