require 'tax_calculator'

class Payslip

  attr_reader :employee, :name, :pay_period
  attr_accessor :gross_income, :income_tax, :net_income, :super

  def initialize(employee)
    @employee   = employee
    @name       = "#{employee.first_name} #{employee.last_name}"
    @pay_period = employee.pay_period
  end

  def generate
    self.gross_income = calc_gross_income
    self.income_tax = TaxCalculator.calculate(employee)
    self.net_income = calc_net_income
    self.super = calc_super
  end

  def calc_gross_income
    employee.annual_salary/12
  end

  def calc_net_income
    gross_income - income_tax
  end

  def calc_super
    (gross_income * employee.super_rate).round
  end

end
