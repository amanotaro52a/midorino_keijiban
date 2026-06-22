class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[show plant_name_autocomplete]

  def plant_name_autocomplete
    search = Post.ransack(plant_name_cont: params[:q])

    plant_names = search.result
                         .where.not(plant_name: [ nil, "" ])
                         .distinct
                         .order(:plant_name)
                         .limit(10)
                         .pluck(:plant_name)

    render partial: "posts/plant_name_autocomplete", locals: { plant_names: plant_names }
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post.nil?
      redirect_to posts_path, alert: t("defaults.flash_message.post_not_found")
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, success: t("defaults.flash_message.created", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_created", item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find_by(id: params[:id])
    if @post.nil?
      redirect_to posts_path, alert: t("defaults.flash_message.post_not_found")
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), success: t("defaults.flash_message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to root_path, success: t("defaults.flash_message.deleted", item: Post.model_name.human), status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :image,
      :plant_name,
    )
  end
end
