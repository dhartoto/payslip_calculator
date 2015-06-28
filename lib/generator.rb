require_relative 'output_file'
require_relative 'staff'
require_relative 'payslip'

class Generator

  attr_accessor :staff, :payslips, :error_message, :completion_message, :validation_errors

  def initialize
    @staff              = Staff.create
    @payslips           = Array.new
    @completion_message = ""
    @validation_errors  = []
    @error_message      = nil
  end

  def run
    unless staff.present?
      self.error_message  = staff.import_error
      abort(error_message)
    end
    generate_payslips
    deliver_output
    puts completion_message
    display_all_validation_errors unless validation_errors.empty?
  end

  def generate_payslips
    staff.list.each do |employee|
      payslip = Payslip.new(employee)
      self.payslips << payslip.generate
    end
    self.validation_errors += staff.validation_errors
    set_completion_message
  end

  def deliver_output
    OutputFile.deliver(self)
  end

  private

  def set_completion_message
    self.completion_message = "#{payslips.count} payslips were"\
    " generated and delivered to the output folder with #{validation_errors.count}"\
    " errors."
  end

  def display_all_validation_errors
    puts "Error log:"
    validation_errors.each {|error| puts error}
  end

end
