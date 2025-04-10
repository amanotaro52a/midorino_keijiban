class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.generate_reset_password_token!
      if UserMailer.reset_password_email(@user).deliver_now
        redirect_to login_path, success: t('.success')
      else
        flash.now[:danger] = t('.email_send_failed')
        render :new,status: :internal_server_error
      end
    else
      redirect_to login_path, success: t('.success')    
    end 
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end
end