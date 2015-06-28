require 'input'
require 'employee'
require 'pry'

class Staff

  attr_reader :list, :error_messages, :import_error

  def initialize(options={})
    @list           = options[:list]
    @error_messages = options[:error_messages]
    @import_error   = options[:import_error]
  end

  def self.create
    file = Input::Data.import
    if file.successful?
      validate_employee_details_and_create_list(file)
    else
      new(import_error: file.error_message)
    end
  end

  def present?
    not list.nil?
  end

  private

  def self.validate_employee_details_and_create_list(file)
    list = []
    error_messages = []
    file.content.each_with_index do |employee_details, index|
      line_nr = index + 1
      validation = Input::Validator.validate(employee_details, line_nr)
      error_messages += validation.error_messages if not validation.successful?
      list << Employee.create(employee_details) if validation.successful?
    end
    new(list: list, error_messages: error_messages)
  end

end
