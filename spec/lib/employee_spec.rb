require 'spec_helper'
require 'employee'

describe Employee do

  let(:employee_details) { "David, Rudd,60050,9%,01 March – 31 March" }

  it 'assigns first name' do
    employee = Employee.create(employee_details)
    expect(employee.first_name).to eq('David')
  end
  it 'assigns last name' do
    employee = Employee.create(employee_details)
    expect(employee.last_name).to eq('Rudd')
  end
  it 'assigns annual salary' do
    employee = Employee.create(employee_details)
    expect(employee.annual_salary).to eq(60050)
  end
  it 'assigns super rate' do
    employee = Employee.create(employee_details)
    expect(employee.super_rate).to eq(0.09)
  end
  it 'assigns super rate' do
    employee = Employee.create(employee_details)
    expect(employee.super_rate).to eq(0.09)
  end
  it 'assigns pay period' do
    employee = Employee.create(employee_details)
    expect(employee.pay_period).to eq("01 March – 31 March")
  end

end
