require "test_helper"

class JsonFileConfigurationTest < ActiveSupport::TestCase
  test "defined path to json file" do
    x = Rails.configuration.x
    assert_not_nil x.json_file["path"]
  end
end
