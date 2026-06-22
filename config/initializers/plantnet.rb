# config/initializers/plantnet.rb
Rails.application.config.x.plantnet_api_key =
  Rails.application.credentials.dig(:plantnet, :api_key).presence || ENV["PLANTNET_API_KEY"]
