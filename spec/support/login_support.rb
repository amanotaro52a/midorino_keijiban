# spec/support/login_support.rb
module LoginSupport
  def login_user(user)
    session[:user_id] = user.id
  end
end
