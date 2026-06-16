class BookmarksController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    current_user.bookmark(@post)
    redirect_to fallback_location: post_path(@post)
  end

  def destroy
    @post = current_user.bookmarks.find(params[:id]).post
    current_user.unbookmark(@post)
    redirect_to fallback_location: post_path(@post)
  end
end
