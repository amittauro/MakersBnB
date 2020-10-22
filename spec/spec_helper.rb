ENV['APP_ENV'] = 'test'
require 'capybara/rspec'
require './app/app'
require 'database_cleaner/active_record'
require_relative 'helper'

Capybara.app = MakersAirBnB

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
end
