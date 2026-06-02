class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  before_action :load_user_from_token, only: [ :edit, :update ]

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to login_path, success: t(".success")
  end

  def edit
    not_authenticated if @user.blank?
  end

  def update
    return not_authenticated if @user.blank?

    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password(params[:user][:password])
      redirect_to login_path, success: t(".success")
    else
      flash.now[:danger] = t(".fail")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user_from_token
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
  end
end
