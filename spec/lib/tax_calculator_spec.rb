require 'spec_helper'
require 'Employee'
require 'tax_calculator'

describe TaxCalculator do

  describe '.calculate' do

    def create_employee(annaul_salary)
      Employee.new(first_name: "John",
        last_name: "So",
        annual_salary: annaul_salary,
        super_rate: 0.095,
        pay_period: "01 March – 31 March")
    end

    it 'calculates tax for $0 - $18,200 bracket' do
      employee = create_employee(18200)
      amount = TaxCalculator.calculate(employee)
      expect(amount).to eq(0)
    end
    it 'calculates tax for $18,2001 - $37,000 bracket' do
      employee = create_employee(37000)
      amount = TaxCalculator.calculate(employee)
      expect(amount).to eq(298)
    end
    it 'calculates tax for $37,001 - $80,000 bracket' do
      employee = create_employee(80000)
      amount = TaxCalculator.calculate(employee)
      expect(amount).to eq(1462)
    end
    it 'calculates tax for $80,001 - $180,000 bracket' do
      employee = create_employee(180000)
      amount = TaxCalculator.calculate(employee)
      expect(amount).to eq(4546)
    end
    it 'calculates tax for $180,00 and over bracket' do
      employee = create_employee(190000)
      amount = TaxCalculator.calculate(employee)
      expect(amount).to eq(4921)
    end
  end

end
