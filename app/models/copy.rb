class Copy
  class << self
    def all
      Copies::Stored.new(self).call
    end

    def since(timestamp)
      return all unless timestamp

      all.select { |copy| copy.created_at >= timestamp.to_i }
    end

    def find(key)
      all.find { |record| record.key == key }
    end

    def airtable
      Copies::Airtable.new(self).call
    end

    def refresh
      copies = Copies::Refresh.new(all, airtable).call
      save(copies)
    end

    def import
      copies = airtable
      save(copies)
    end

    def save(copies)
      File.write(json_file_path, JSON.pretty_generate(copies))
    end

    def json_file_path
      Rails.configuration.x.json_file["path"]
    end
  end

  attr_accessor :copy, :created_at
  attr_reader :key

  def initialize(key:, copy:, created_at:)
    @key = key
    @copy = copy
    @created_at = created_at
  end

  def ==(other)
    key == other.key && copy == other.copy
  end

  def formatted(params)
    formatted_copy = copy.dup
    params.each do |key, value|
      formatted_copy = formatted_copy.gsub("{#{key}}", value)
                                     .gsub("{#{key}, datetime}", formatted_datetime(value))
    end
    { value: formatted_copy }
  end

  def to_json(*args)
    { key: key, copy: copy, created_at: created_at }.to_json(*args)
  end

  def update(copy:, created_at:)
    self.copy = copy
    self.created_at = created_at
  end

  private

    def formatted_datetime(value)
      Time.zone.at(value.to_i).strftime("%a %b %-d %-l:%M:%S%p").sub("Tue", "Tues")
    end
end
