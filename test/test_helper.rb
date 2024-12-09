# SimpleCovのセットアップ
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/test/'
  add_filter '/config/'
end

# Docker環境用にカバレッジ出力先を指定
SimpleCov.coverage_dir 'tmp/coverage'

puts "SimpleCov started. Coverage report will be generated in tmp/coverage."

# 既存のコード
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
