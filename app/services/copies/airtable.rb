class Copies::Airtable
  def initialize(model)
    @model = model
  end

  def call
    records = CopyTable.all
    records.map do |raw_copy|
      model.new(key: raw_copy.fields["Key"], copy: raw_copy.fields["Copy"], created_at: Time.zone.now.to_i)
    end
  end

  private

    attr_reader :model
end
