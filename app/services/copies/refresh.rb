class Copies::Refresh
  def initialize(stored_copies, airtable_copies)
    @stored_copies = stored_copies
    @airtable_copies = airtable_copies
  end

  def call
    airtable_copies.each do |airtable_copy|
      next if stored_copies.include? airtable_copy

      stored_copy = stored_copies.find { |record| record.key == airtable_copy.key }
      if stored_copy
        stored_copy.update(copy: airtable_copy.copy, created_at: airtable_copy.created_at)
      else
        stored_copies << airtable_copy
      end
    end
    stored_copies
  end

  private

    attr_reader :stored_copies, :airtable_copies

end