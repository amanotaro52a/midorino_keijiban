class AuthenticationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:google_callback]
  skip_before_action :require_login, only: [:google_callback]

  def google_callback
    provider = 'google'
    
    # 認証コードをトークンに交換
    client = OAuth2::Client.new(
      ENV['GOOGLE_CLIENT_ID'],
      ENV['GOOGLE_CLIENT_SECRET'],
      site: 'https://accounts.google.com',
      authorize_url: '/o/oauth2/auth',
      token_url: '/o/oauth2/token'
    )
    
    # Googleから返された認証コードを使ってトークンを取得
    begin
      token = client.auth_code.get_token(params[:code], redirect_uri: 'http://localhost:3000/authentications/google_callback')
    rescue OAuth2::Error => e
      Rails.logger.error "Google認証コードの交換に失敗しました: #{e.message}"
      redirect_to login_path, alert: 'Google認証コードの交換に失敗しました。再度お試しください。'
      return
    end

    # Google APIからユーザー情報を取得
    google_user_info = fetch_google_user_info(token)

    # ユーザー情報の取得に失敗した場合
    if google_user_info.nil? || google_user_info['sub'].nil?
      Rails.logger.error "Google認証失敗: ユーザー情報の取得に失敗しました"
      redirect_to login_path, alert: t('authentications.google_callback.failure')
      return
    end

    # 既存ユーザーか新規ユーザーを確認または作成
    if @user = login_from(provider)
      redirect_to diaries_path, notice: "ログイン成功しました。"
    else
      begin
        @user = create_from(provider, google_user_info)
        reset_session
        auto_login(@user)
        redirect_to diaries_path, notice: "Googleからログインしました。"
      rescue => e
        Rails.logger.error "Google認証に失敗しました: #{e.message}"
        redirect_to login_path, alert: "Google認証に失敗しました。"
      end
    end
  end
  
  private
  
  # Google APIからユーザー情報を取得する
  def fetch_google_user_info(token)
    url = 'https://www.googleapis.com/oauth2/v3/userinfo'
    response = token.get(url)
    if response.status == 200
      response.parsed
    else
      Rails.logger.error "Google APIからユーザー情報を取得できませんでした: #{response.status}"
      nil
    end
  end
  
  # 新規ユーザーの作成
  def create_from(provider, google_user_info)
    user = User.find_or_create_by(email: google_user_info['email']) do |u|
      u.name = google_user_info['name']
      u.password = SecureRandom.hex(15)  # パスワードをランダムに設定
    end

    # 認証情報の作成
    authentication = user.authentications.find_or_create_by(provider: provider, uid: google_user_info['sub'])
    authentication.save!
    user
  end
end
