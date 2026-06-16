class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top]

  def top
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
  end
end
