class TaxCalculator

  def self.calculate(employee)
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

end
