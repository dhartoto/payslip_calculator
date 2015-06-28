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
    before { allow(TaxCalculator).to receive(:calculate) { 1110 } }

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

end
