# app/mailers/test_mailer.rb
class TestMailer < ApplicationMailer
  default from: 'info@midorino-keijiban.com'
  
  def test_email
    mail(to: 'ppamnta8pa@gmail.com', subject: 'Test Email', body: 'This is a test email.')
  end
end
  