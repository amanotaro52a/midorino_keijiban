Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Settings.google.GOOGLE_CLIENT_ID, Settings.google.GOOGLE_CLIENT_SECRET,
  {
    scope: 'email,profile',
    prompt: 'select_account',
    access_type: 'offline',  # リフレッシュトークンを取得するオプション
    redirect_uri: 'http://localhost:3000/authentications/google_callback'
  }
end  
