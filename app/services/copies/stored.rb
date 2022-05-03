class Copies::Stored
  def initialize(model)
    @model = model
  end

  def call
    records = JSON.parse(json_file_content, symbolize_names: true)
    records.map do |record|
      model.new(key: record[:key],
               copy: record[:copy],
               created_at: record[:created_at])
    end
  end

  private

    attr_reader :model

    def json_file_content
      File.read(model.json_file_path)
    end
end
