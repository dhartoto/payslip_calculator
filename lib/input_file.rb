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
    if not file_present?
      msg = "Input file has not been uploaded. Please save your file"\
        " in the 'input' folder, type 'cont' then click enter."
      new(error_message: msg)
    elsif import_file.empty?
      msg = "Input file is blank. Please add employee details to file, type"\
       " 'cont' then click enter."
      new(error_message: msg)
    else
      new(content: build_content)
    end
  end

  def successful?
    !!content
  end

  private

  def self.file_present?
    File.exists?(FULL_PATH)
  end

  def self.import_file
    File.read(FULL_PATH)
  end

  def self.build_content
    file = import_file
    file.split(/\n/)
  end
end
