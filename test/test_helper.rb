ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'shoulda'
require 'factory_girl'
FactoryGirl.find_definitions

require 'declarative_authorization/maintenance'

class ActionController::TestCase
  include Devise::TestHelpers
  include Authorization::TestHelper
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
