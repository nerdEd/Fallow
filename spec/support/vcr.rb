require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassette_library'
  c.stub_with                :fakeweb
  c.ignore_localhost         = true
  c.default_cassette_options = {:record => :none}
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
