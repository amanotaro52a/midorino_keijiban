class UserMailer < ApplicationMailer
  default from: 'info@midorino-keijiban.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = User.find(user.id)
    # Heroku環境のURLを生成
    @url = edit_password_reset_url(@user.reset_password_token, host: "infinite-coast-76610-6cf707f3e38e.herokuapp.com")
    mail(to: user.email, subject: t('defaults.password_reset'))
  end

  def test_email(to)
    @user = "Hello!"
    mail(to: to, subject: 'Test Email')
  end
end