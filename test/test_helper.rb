ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha'

# Load up factories
require 'factory_girl'
Factory.find_definitions

# Setup VCR
require 'vcr'
VCR.config do |c|
  c.cassette_library_dir     = 'test/cassette_library'
  c.stub_with                :fakeweb
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
end

class ActiveSupport::TestCase

end
