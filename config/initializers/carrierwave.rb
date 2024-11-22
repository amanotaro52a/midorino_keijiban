require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'Google',
    google_project: ENV['GOOGLE_CLOUD_PROJECT'],
    google_json_key_string: ENV['GOOGLE_CLOUD_KEYFILE_JSON']
  }
  config.fog_directory  = ENV['GOOGLE_CLOUD_STORAGE_BUCKET']
end
