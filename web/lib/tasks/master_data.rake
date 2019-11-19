namespace :master_data do
  task import: :environment do
    importer = Kd::MasterDataImporter.new
    importer.import_staffs
  end
end
