require 'sendgrid-ruby'
include SendGrid 

class SendgridUserMailer < ApplicationMailer
  def self.reset_password_email(user)
    @user = user
    @url =  Rails.application.routes.url_helpers.edit_password_reset_url(@user.reset_password_token, host: ENV.fetch('MAILER_HOST'))
    from = Email.new(email: 'info@www.midorino-keijiban.com')
    to = Email.new(email: @user.email)
    subject = I18n.t('defaults.password_reset')

    html_content = Content.new(type: 'text/html', value: render_html_template)
    text_content = Content.new(type: 'text/plain', value: render_text_template)

    mail = SendGrid::Mail.new
    mail.from = from
    mail.subject = subject

    personalization = Personalization.new
    personalization.add_to(to)
    mail.add_personalization(personalization)

    mail.add_content(text_content)
    mail.add_content(html_content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    response.status_code.to_i == 202
  end

  def self.render_html_template
    ApplicationController.render(
      template: 'user_mailer/reset_password_email',
      formats: [:html],
      assigns: { user: @user, url: @url }
    )
  end

  def self.render_text_template
    ApplicationController.render(
      template: 'user_mailer/reset_password_email',
      formats: [:text],
      assigns: { user: @user, url: @url }
    )
  end
end