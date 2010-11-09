ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha'

# Load up factories
require 'factory_girl'
Factory.find_definitions

class ActiveSupport::TestCase

end
