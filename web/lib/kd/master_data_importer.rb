class Kd::MasterDataImporter
  def path_to_file(filename)
    Rails.root.join('db', 'master_data', filename)
  end

  def import(filename, &block)
    Kd::CsvReader.new.parse(path_to_file(filename)) do |row|
      yield(row)
    end
  end

  def import_staffs
    ActiveRecord::Base.transaction do
      User.delete_all

      import('staffs.csv') do |row|
        uuid = row[1]
        full_name = row[2]
        gender = row[3]&.downcase

        User.create!(uuid: uuid, full_name: full_name, gender: gender)
      end
    end
  end
end
