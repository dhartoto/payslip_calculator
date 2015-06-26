require 'input_file'
require 'output_file'
require 'staff'

class Generator

  attr_accessor :staff, :payslips, :error_message, :success_message

  def initialize
    @staff           = Staff.create
    @payslips        = Array.new
    @success_message = "Payslips have been generated and may be retreived from the 'output' folder."
    @error_message   = nil
  end

  def run
    until staff.present?
      self.error_message  = staff.error_message + "\n"
      self.error_message += "Or type 'exit' and hit 'Enter' to exit the program."
      puts error_message
      input = gets.chomp
      abort("Exiting...Goodbye!") if input == 'exit'
      self.staff = Staff.create
    end
    generate_payslips
    deliver_output
    puts success_message
  end

  def generate_payslips
    staff.list.each do |employee|
      payslips << Payslip.generate(employee)
    end
  end

  def deliver_output
    OutputFile.deliver(self)
  end

end
