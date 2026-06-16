class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t("defaults.flash_message.updated", item: User.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_updated", item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @bookmark_posts = current_user.bookmark_posts.includes(:user).order(created_at: :desc)
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :name, :avatar, :avatar_cache)
  end
end
