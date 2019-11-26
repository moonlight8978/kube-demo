class CalculatorWorker
  include Sidekiq::Worker

  def perform(calculating_id)
    calculating = Calculating.find(calculating_id)
    input = Tempfile.create("calculating_#{SecureRandom.hex(16)}") do |raw|
      raw.write(calculating.raw.download)
      raw.rewind

      Kd::CsvReader.new(headers: false).parse(raw) do |row|
        row.first.to_i
      end
    end
    calculating.input = input
    calculating.result = input.reduce(:+)
    calculating.save(validate: false)
  end
end
