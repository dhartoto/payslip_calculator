require 'spec_helper'
require 'payslip'
require 'employee'

describe 'Payslip' do

  describe '.new' do
    let(:employee) do
      Employee.new(first_name: "John",
        last_name: "So",
        annual_salary: 67000,
        super_rate: 0.095,
        pay_period: "01 March – 31 March")
    end

    it 'assigns employee' do
      payslip = Payslip.new(employee)
      expect(payslip.employee).to be_an_instance_of(Employee)
    end
    it 'generates payslip with full name' do
      payslip = Payslip.new(employee)
      expect(payslip.name).to eq("John So")
    end
    it 'generates payslip with pay period' do
      payslip = Payslip.new(employee)
      expect(payslip.pay_period).to eq("01 March – 31 March")
    end
  end

  describe '.generate' do

    let(:employee) do
      Employee.new(first_name: "John",
        last_name: "So",
        annual_salary: 67000,
        super_rate: 0.095,
        pay_period: "01 March – 31 March")
    end

    it 'generates payslip with monthly gross income amount' do
      payslip = Payslip.new(employee)
      payslip.generate
      expect(payslip.gross_income).to eq(5583)
    end
    it 'generates payslip with monthly income tax amount' do
      payslip = Payslip.new(employee)
      payslip.generate
      expect(payslip.income_tax).to eq(1110)
    end
    it 'generates payslip with monthly net income amount' do
      payslip = Payslip.new(employee)
      payslip.generate
      expect(payslip.net_income).to eq(4473)
    end
    it 'generates payslip with monthly super amount' do
      payslip = Payslip.new(employee)
      payslip.generate
      expect(payslip.super).to eq(530)
    end

  end

  describe '.calc_income_tax' do

    def create_employee(annaul_salary)
      Employee.new(first_name: "John",
        last_name: "So",
        annual_salary: annaul_salary,
        super_rate: 0.095,
        pay_period: "01 March – 31 March")
    end

    it 'calculates tax for $0 - $18,200 bracket' do
      employee = create_employee(18200)
      payslip = Payslip.new(employee)
      amount = payslip.calc_income_tax
      expect(amount).to eq(0)
    end
    it 'calculates tax for $18,2001 - $37,000 bracket' do
      employee = create_employee(37000)
      payslip = Payslip.new(employee)
      amount = payslip.calc_income_tax
      expect(amount).to eq(298)
    end
    it 'calculates tax for $37,001 - $80,000 bracket' do
      employee = create_employee(80000)
      payslip = Payslip.new(employee)
      amount = payslip.calc_income_tax
      expect(amount).to eq(1462)
    end
    it 'calculates tax for $80,001 - $180,000 bracket' do
      employee = create_employee(180000)
      payslip = Payslip.new(employee)
      amount = payslip.calc_income_tax
      expect(amount).to eq(4546)
    end
    it 'calculates tax for $180,00 and over bracket' do
      employee = create_employee(190000)
      payslip = Payslip.new(employee)
      amount = payslip.calc_income_tax
      expect(amount).to eq(4921)
    end
  end

end
