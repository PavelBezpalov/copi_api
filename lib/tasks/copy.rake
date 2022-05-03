namespace :copy do
  desc "Import copies from Airtable and write to json file"
  task import: :environment do
    Copy.import
  end
end
