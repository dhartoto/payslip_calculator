module Input

  class Data

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
        msg = "'employee_details.csv' has not been uploaded. Please save it"\
          " into the 'input' folder then try again."
        new(error_message: msg)
      elsif import_file.empty?
        msg = "'employee_details.csv' is blank. Please add employee details to"\
        " file then try again."
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
      file.split(/\r?\n/)
    end
  end

  class Validator

    attr_reader :valid, :error_messages

    def initialize(options={})
      @valid = options[:valid]
      @error_messages = options[:error_messages]
    end

    def self.validate(data, line_nr)
      data_arr = data.split(',')
      error_messages = check_for_errors(data_arr, line_nr)
      error_messages.empty? ? new(valid: true) : new(error_messages: error_messages)
    end

    def successful?
      !!valid
    end

    private

      def self.check_for_errors(array, line_nr)
        # First validation is seperated because other validation fails if input nr < 5.
        # This is a limitation in the validation algorithm.
        if not_enough_user_inputs?(array)
          error = ["Line #{line_nr}: Not enough user inputs."]
        else
          error = []
          error << "Line #{line_nr}: Annual salary cannot be negative." if salary_negative?(array)
          error << "Line #{line_nr}: Super rate has to be between 0% and 50% (inclusive)."\
            if super_rate_exceed_range?(array)
        end
        error
      end

      def self.salary_negative?(array)
        array[2].to_i < 0
      end

      def self.not_enough_user_inputs?(array)
        array.length != 5
      end

      def self.super_rate_exceed_range?(array)
        rate = array[3].split('%').first.to_f
        rate <= 0 || rate >= 50
      end

  end

end
