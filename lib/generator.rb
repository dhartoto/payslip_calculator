require 'InputFile'
require 'Staff'

class Generator

  attr_accessor :staff, :payslips, :display

  def initialize
    @staff = Staff.create
    @payslips = Array.new
    @display = nil
  end

  def self.run
    until employees.present?
      self.display = employees.error_message + "\n"
      self.display += "Or type 'exit' and hit 'Enter' to exit the program."
      input = gets.chomp.downcase
      abort("Exiting...Goodbye!") if input == 'exit'
      self.emloyees = Employee.create_list
    end
    generate_payslips
  end


end
