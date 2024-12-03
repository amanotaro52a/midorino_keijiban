class DiariesController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  def index
    Rails.logger.info("Params: #{params[:q]}")
    @q = Diary.ransack(params[:q])
    Rails.logger.info("Search Object: #{@q.inspect}")
    @diaries = @q.result(distinct: true)
    Rails.logger.info("Result: #{@diaries.inspect}")
  rescue => e
    Rails.logger.error("Error: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    raise
  end
  

  def new
    @diary = Diary.new
  end

  def show
    @diary = Diary.find_by(id: params[:id])
    if @diary.nil?
      redirect_to diaries_path, alert: "日記が見つかりませんでした"
    end
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      redirect_to diaries_path
      flash[:success] = t('defaults.flash_message.created', item: Diary.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Diary.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @diary = current_user.diaries.find_by(id: params[:id])
    if @diary.nil?
      redirect_to diaries_path, alert: "日記が見つかりませんでした"
    end
  end

  def update
    @diary = current_user.diaries.find(params[:id])
    if @diary.update(diary_params)
      redirect_to diary_path(@diary)
      flash[:success] = t('defaults.flash_message.updated', item: Diary.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: Diary.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    diary = current_user.diaries.find(params[:id])
    diary.destroy!
    redirect_to diaries_path, status: :see_other
    flash[:success] = t('defaults.flash_message.deleted', item: Diary.model_name.human)
  end

  private

  def diary_params
    params.require(:diary).permit(
      :title, 
      :summary_content, 
      :thumbnail_image, 
      :plant_name, 
      :variety_name, 
      :cultivation_method, 
      :cultivation_location,
      growth_stages_attributes: [:id, :growth_stage_contents, :image, :_destroy]
    )
  end
end