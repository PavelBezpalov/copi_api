class Copies::Refresh
  def call
    copydata = CopyTable.all
    @copies = copydata.map do |raw_copy|
      Copy.new(key: raw_copy.fields["Key"], copy: raw_copy.fields["Copy"], created_at: Time.zone.now.to_i)
    end
    dump_to_json
  end

  private

  attr_reader :copies

    def json_file_path
      Rails.configuration.x.json_file["path"]
    end

    def json_copydata
      JSON.pretty_generate(copies)
    end

    def dump_to_json
      File.write(json_file_path, json_copydata)
    end
end
