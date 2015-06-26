class InputFile

  FOLDER    = 'input/'
  FILE_NAME = 'employee_details.csv'
  FULL_PATH = FOLDER + FILE_NAME

  attr_accessor :error_message, :content

  def initialize(options={})
    @error_message = options[:error_message]
    @content = options[:content]
  end

  def self.import
    resp = File.read(FULL_PATH)
    resp = resp.split(/\n/)
    new(content: resp)
  end

  def successful?
    !!content
  end
end
