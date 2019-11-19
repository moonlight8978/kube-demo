class Kd::CsvReader
  DEFAULT_OPTIONS = {
    encoding: "UTF-8:UTF-8",
    headers: :first_row,
    skip_blanks: true,
  }

  attr_reader :options

  def initialize(options = {})
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def parse(csv, &block)
    require 'csv'
    results = []
    CSV.foreach(csv, options) do |row|
      result = yield(row)
      results << result
    end
    results
  rescue EncodingError, CSV::MalformedCSVError
    raise InvalidFileError
  end
end
