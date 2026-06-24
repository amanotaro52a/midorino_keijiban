require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/'
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# shoulda-matchers の設定
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# spec/support 配下を自動 require
# ※ rails_helper.rb 自身は spec/ 直下に置くこと（spec/support/ に置かない）
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# マイグレーション未適用チェック
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # FactoryBot のメソッドをグローバルに使えるようにする
  config.include FactoryBot::Syntax::Methods

  # LoginSupport / RequestLoginSupport の include は spec/support/login_support.rb で管理

  # ActiveJob のテストヘルパーを model / request の両方に include
  # （変更前は type: :model のみだったためメール送信テストが request spec で使えなかった）
  config.include ActiveJob::TestHelper, type: :model
  config.include ActiveJob::TestHelper, type: :request

  config.use_transactional_fixtures = true

  # ファイル配置から spec の type を自動推論する
  # （有効化することで type: の手動指定が不要になり、誤配置も防ぎやすくなる）
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
