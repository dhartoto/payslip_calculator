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
    self.income_tax = calc_income_tax
    self.net_income = calc_net_income
    self.super = calc_super
  end

  def calc_gross_income
    employee.annual_salary/12
  end

  def calc_income_tax
    salary = employee.annual_salary
    case
    when salary <= 18200
      amount = 0
    when salary > 18200 && salary <= 37000
      amount = ((salary - 18200) * 0.19)/12
    when salary > 37000 && salary <= 80000
      amount = (3572 + (salary - 37000) * 0.325)/12
    when salary > 80000 && salary <= 180000
      amount = (17547 + (salary - 80000) * 0.37)/12
    else
      amount = (54547 + (salary - 180000) * 0.45)/12
    end
    amount.round
  end

  def calc_net_income
    gross_income - income_tax
  end

  def calc_super
    (gross_income * employee.super_rate).round
  end

end
