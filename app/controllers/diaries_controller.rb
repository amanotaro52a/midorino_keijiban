class DiariesController < ApplicationController
  def index
    @diaries = Diary.includes(:user).page(params[:page])
  end

  def new
    @diary = Diary.new
  end

  def show
    @diary = Diary.find(params[:id])
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      redirect_to diaries_path, success: t('defaults.flash_message.created', item: Diary.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Diary.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def diary_params
    params.require(:diary).permit(:title, :content, :diary_image)
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :content, :diary_image, :diary_image_cache)
  end
end
