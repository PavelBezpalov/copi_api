class Copy
  class << self
    def all
      records = Copies::All.new.call
      records.map do |record|
        self.new(key: record[:key],
                 copy: record[:copy],
                 created_at: record[:created_at])
      end
    end

    def since(timestamp)
      return all unless timestamp

      all.select { |copy| copy.created_at > Time.at(timestamp.to_i).to_datetime }
    end

    def find(key)
      all.find { |record| record.key == key }
    end
  end

  attr_accessor :copy
  attr_reader :key, :created_at

  def initialize(key:, copy:, created_at:)
    @key = key
    @copy = copy
    @created_at = DateTime.iso8601(created_at)
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

  private

    def formatted_datetime(value)
      Time.at(value.to_i).utc.strftime("%a %b %-d%l:%M:%S%p").sub("Tue", "Tues")
    end
end
