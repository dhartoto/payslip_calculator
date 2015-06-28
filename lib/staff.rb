require 'input'
require 'employee'
require 'pry'

class Staff

  attr_reader :list, :validation_errors, :import_error

  def initialize(options={})
    @list           = options[:list]
    @validation_errors = options[:validation_errors]
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
    validation_errors = []
    file.content.each_with_index do |employee_details, index|
      line_nr = index + 1
      validation = Input::Validator.validate(employee_details, line_nr)
      validation_errors += validation.error_messages if not validation.successful?
      list << Employee.create(employee_details) if validation.successful?
    end
    new(list: list, validation_errors: validation_errors)
  end

end
