class ContactMailer < ApplicationMailer
  def contact_mail(contact)
    @contact = contact
    mail(to: @contact.email, bcc:"midorinokeijiban.info@gmail.com", subject: t('.contact_information'))
  end  
end
