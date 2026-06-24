module LoginSupport
  def login_user(user)
    session[:user_id] = user.id
  end
end

# request spec 用のログインヘルパーを別途定義
# Sorcery はセッションに直接代入できないため、
# 実際にログインリクエストを送ってセッションを確立する
module RequestLoginSupport
  def login_user(user)
    post login_path, params: { email: user.email, password: 'password' }
  end
end

RSpec.configure do |config|
  config.include LoginSupport, type: :controller
  config.include RequestLoginSupport, type: :request
end
