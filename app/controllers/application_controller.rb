class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # ログインチェックを行う
  before_action :require_login, unless: :google_logged_in?

  add_flash_types :success, :danger

  private


  # ログインしていない場合にリダイレクト
  def not_authenticated
    redirect_to login_path, danger: t('defaults.flash_message.require_login')
  end

  # Googleログイン状態かを確認するメソッド
  def google_logged_in?
    session[:user_id].present? # Googleログインでセッションがセットされていればtrue
  end
end
