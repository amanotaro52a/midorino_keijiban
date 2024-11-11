class UserMailer < ApplicationMailer
  default from: 'info@midorino-keijiban.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = user
    # Heroku上でのアプリURLをベースにし、@user.reset_password_tokenを含める
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: @user.email, subject: t('defaults.password_reset'))
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: '私の素敵なサイトへようこそ')
  end  
end