class ContactsController < ApplicationController
    skip_before_action :require_login, only: %i[new create]  
  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact).deliver_now
      redirect_to root_path, success: t('.success')
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Contact.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end
  
  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end  
end
