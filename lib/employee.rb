class Employee

  attr_reader :first_name, :last_name, :annual_salary, :super_rate, :pay_period

  def initialize(options={})
    @first_name    = options[:first_name]
    @last_name     = options[:last_name]
    @annual_salary = options[:annual_salary]
    @super_rate    = options[:super_rate]
    @pay_period    = options[:pay_period]
  end

  def self.create(details)
    details_array = details.split(',')
    new(first_name: get_first_name(details_array),
      last_name: get_last_name(details_array),
      annual_salary: get_annual_salary(details_array),
      super_rate: get_super_rate(details_array),
      pay_period: get_pay_period(details_array)
      )
  end

  private

  def self.get_first_name(array)
    array[0].strip
  end

  def self.get_last_name(array)
    array[1].strip
  end

  def self.get_annual_salary(array)
    array[2].strip.to_i
  end

  # 9% = 0.09
  def self.get_super_rate(array)
    array[3].strip.split('%').first.to_f/100
  end

  def self.get_pay_period(array)
    array[4].strip
  end

end
