ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "vcr"
require "minitest/autorun"

VCR.configure do |c|
  c.cassette_library_dir = "test/fixtures/files/vcr_cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data("<API_KEY>") { Rails.application.credentials.airtable.api_key }
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...
end
