Airrecord.api_key = Rails.application.credentials.airtable.api_key

class CopyTable < Airrecord::Table
  self.base_key = Rails.application.credentials.airtable.base_key
  self.table_name = Rails.application.credentials.airtable.table_id
end
