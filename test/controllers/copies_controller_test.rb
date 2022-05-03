require "test_helper"

class CopiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @json_file_path = Rails.configuration.x.json_file["path"]
  end

  teardown do
    Rails.configuration.x.json_file["path"] = @json_file_path
  end

  test "should get all copies" do
    json_file_path = "test/fixtures/files/first_copies.json"
    json_file_content = File.read(json_file_path)
    Rails.configuration.x.json_file["path"] = json_file_path

    get "/copy"

    assert_response :success
    assert_nothing_raised { JSON.parse(response.body) }
    assert_equal(JSON.parse(json_file_content),
                 JSON.parse(response.body))
  end

  test "should get all copies with since filter" do
    third_copies_path = "test/fixtures/files/third_copies.json"
    Rails.configuration.x.json_file["path"] = third_copies_path
    third_copies_filtered_path = "test/fixtures/files/third_copies_filtered.json"
    third_copies_filtered_content = File.read(third_copies_filtered_path)

    get "/copy?since=1651558800"

    assert_response :success
    assert_nothing_raised { JSON.parse(response.body) }
    assert_equal(JSON.parse(third_copies_filtered_content),
                 JSON.parse(response.body))
  end

  test "should get formatted greeting" do
    json_file_path = "test/fixtures/files/first_copies.json"
    Rails.configuration.x.json_file["path"] = json_file_path

    get "/copy/greeting?name=John&app=Bridge"

    assert_response :success
    assert_nothing_raised { JSON.parse(response.body) }
    assert_equal({ value: "Hi John, welcome to Bridge!" },
                 JSON.parse(response.body, symbolize_names: true))
  end

  test "should get formatted intro.created_at" do
    json_file_path = "test/fixtures/files/first_copies.json"
    Rails.configuration.x.json_file["path"] = json_file_path

    get "/copy/intro.created_at?created_at=1603814215"

    assert_response :success
    assert_nothing_raised { JSON.parse(response.body) }
    assert_equal({ value: "Intro created on Tues Oct 27 3:56:55PM" },
                 JSON.parse(response.body, symbolize_names: true))
  end

  test "should get formatted intro.updated_at" do
    json_file_path = "test/fixtures/files/first_copies.json"
    Rails.configuration.x.json_file["path"] = json_file_path

    get "/copy/intro.updated_at?updated_at=1604063144"

    assert_response :success
    assert_nothing_raised { JSON.parse(response.body) }
    assert_equal({ value: "Intro updated on Fri Oct 30 1:05:44PM" },
                 JSON.parse(response.body, symbolize_names: true))
  end

  test "should get formatted time" do
    json_file_path = "test/fixtures/files/second_copies.json"
    Rails.configuration.x.json_file["path"] = json_file_path

    get "/copy/time?time=1604352707"

    assert_response :success
    assert_nothing_raised { JSON.parse(response.body) }
    assert_equal({ value: "It is Mon Nov 2 9:31:47PM" },
                 JSON.parse(response.body, symbolize_names: true))
  end

  test "should get formatted bye" do
    json_file_path = "test/fixtures/files/third_copies.json"
    Rails.configuration.x.json_file["path"] = json_file_path

    get "/copy/bye"

    assert_response :success
    assert_nothing_raised { JSON.parse(response.body) }
    assert_equal({ value: "Goodbye" },
                 JSON.parse(response.body, symbolize_names: true))
  end

  test "should refresh copies from airtable" do
    travel_to Time.zone.at(1651557600) do
      VCR.use_cassette("first run") do
        get "/copy/refresh"
        assert_response :success
      end
    end
  end
end
