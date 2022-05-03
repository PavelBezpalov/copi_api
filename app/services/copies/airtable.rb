class Copies::Airtable
  def initialize(model)
    @model = model
  end

  def call
    records = CopyTable.all
    records.map do |record|
      model.new(key: record["Key"], copy: record["Copy"], created_at: Time.zone.now.to_i)
    end
  end

  private

    attr_reader :model
end
