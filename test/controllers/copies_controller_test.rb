require "test_helper"

class CopiesControllerTest < ActionDispatch::IntegrationTest
  test "should get all copies" do
    first_copies_path = "test/fixtures/files/first_copies.json"
    first_copies_content = File.read(first_copies_path)

    Copy.stub :json_file_path, first_copies_path do
      get "/copy"

      assert_response :success
      assert_nothing_raised { JSON.parse(response.body) }
      assert_equal(JSON.parse(first_copies_content),
                   JSON.parse(response.body))
    end
  end

  test "should get all copies with since filter" do
    third_copies_path = "test/fixtures/files/third_copies.json"
    third_copies_filtered_path = "test/fixtures/files/third_copies_filtered.json"
    third_copies_filtered_content = File.read(third_copies_filtered_path)

    Copy.stub :json_file_path, third_copies_path do
      get "/copy?since=1651558800"

      assert_response :success
      assert_nothing_raised { JSON.parse(response.body) }
      assert_equal(JSON.parse(third_copies_filtered_content),
                   JSON.parse(response.body))
    end
  end

  test "should get formatted greeting" do
    first_copies_path = "test/fixtures/files/first_copies.json"

    Copy.stub :json_file_path, first_copies_path do
      get "/copy/greeting?name=John&app=Bridge"

      assert_response :success
      assert_nothing_raised { JSON.parse(response.body) }
      assert_equal({ value: "Hi John, welcome to Bridge!" },
                   JSON.parse(response.body, symbolize_names: true))
    end
  end

  test "should get formatted intro.created_at" do
    first_copies_path = "test/fixtures/files/first_copies.json"

    Copy.stub :json_file_path, first_copies_path do
      get "/copy/intro.created_at?created_at=1603814215"

      assert_response :success
      assert_nothing_raised { JSON.parse(response.body) }
      assert_equal({ value: "Intro created on Tues Oct 27 3:56:55PM" },
                   JSON.parse(response.body, symbolize_names: true))
    end
  end

  test "should get formatted intro.updated_at" do
    first_copies_path = "test/fixtures/files/first_copies.json"

    Copy.stub :json_file_path, first_copies_path do
      get "/copy/intro.updated_at?updated_at=1604063144"

      assert_response :success
      assert_nothing_raised { JSON.parse(response.body) }
      assert_equal({ value: "Intro updated on Fri Oct 30 1:05:44PM" },
                   JSON.parse(response.body, symbolize_names: true))
    end
  end

  test "should get formatted time" do
    second_copies_path = "test/fixtures/files/second_copies.json"

    Copy.stub :json_file_path, second_copies_path do
      get "/copy/time?time=1604352707"

      assert_response :success
      assert_nothing_raised { JSON.parse(response.body) }
      assert_equal({ value: "It is Mon Nov 2 9:31:47PM" },
                   JSON.parse(response.body, symbolize_names: true))
    end
  end

  test "should get formatted bye" do
    third_copies_path = "test/fixtures/files/third_copies.json"

    Copy.stub :json_file_path, third_copies_path do
      get "/copy/bye"

      assert_response :success
      assert_nothing_raised { JSON.parse(response.body) }
      assert_equal({ value: "Goodbye" },
                   JSON.parse(response.body, symbolize_names: true))
    end
  end

  test "should refresh copies from airtable" do
    second_copies_path = "test/fixtures/files/first_copies.json"
    first_copies_content = File.read(second_copies_path)
    expected_copies = JSON.parse(first_copies_content)
    json_file_path = Copy.json_file_path
    File.write(json_file_path, [].to_json)

    travel_to Time.zone.at(1651557600) do
      VCR.use_cassette("first refresh") do
        get "/copy/refresh"

        json_file_content = File.read(json_file_path)
        actual_copies = JSON.parse(json_file_content)

        assert_response :success
        assert expected_copies.difference(actual_copies).none?
      end
    end
  end

  test "should refresh copies from airtable and add new" do
    second_copies_path = "test/fixtures/files/first_copies.json"
    first_copies_content = File.read(second_copies_path)
    second_copies_path = "test/fixtures/files/second_copies.json"
    second_copies_content = File.read(second_copies_path)
    expected_copies = JSON.parse(second_copies_content)
    json_file_path = Copy.json_file_path
    File.write(json_file_path, first_copies_content)

    travel_to Time.zone.at(1651558200) do
      VCR.use_cassette("second refresh") do
        get "/copy/refresh"

        json_file_content = File.read(json_file_path)
        actual_copies = JSON.parse(json_file_content)

        assert_response :success
        assert expected_copies.difference(actual_copies).none?,
               "expected: #{expected_copies.inspect}\nactual: #{actual_copies.inspect}"
      end
    end
  end

  test "should refresh copies from airtable and add new and update old" do
    second_copies_path = "test/fixtures/files/second_copies.json"
    second_copies_content = File.read(second_copies_path)
    third_copies_path = "test/fixtures/files/third_copies.json"
    third_copies_content = File.read(third_copies_path)
    expected_copies = JSON.parse(third_copies_content)
    json_file_path = Copy.json_file_path
    File.write(json_file_path, second_copies_content)

    travel_to Time.zone.at(1651558800) do
      VCR.use_cassette("third refresh") do
        get "/copy/refresh"

        json_file_content = File.read(json_file_path)
        actual_copies = JSON.parse(json_file_content)

        assert_response :success
        assert expected_copies.difference(actual_copies).none?,
               "expected: #{expected_copies.inspect}\nactual: #{actual_copies.inspect}"
      end
    end
  end
end
