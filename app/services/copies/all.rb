class Copies::All
  def call
    JSON.parse(json_file_content, symbolize_names: true)
  end

  private

    attr_reader :model

    def json_file_path
      Rails.configuration.x.json_file["path"]
    end

    def json_file_content
      File.read(json_file_path)
    end
end
