module PostsHelper
  def show_post_actions?(post)
    current_user.present? && current_user != post.user
  end

  def already_liked?(post)
    current_user.present? && current_user.likes.exists?(post: post)
  end

  def already_bookmarked?(post)
    current_user.present? && current_user.bookmark?(post)
  end
end
