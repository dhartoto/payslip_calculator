require "csv"
require 'pry'

class OutputFile

  FOLDER = "output"
  FILENAME = "payslip_information.csv"

  def self.deliver(obj)
    CSV.open("#{FOLDER}/#{FILENAME}", "w") do |csv|
      obj.list.each do |payslip|
        payslip_string = get_payslip_array(payslip)
        csv << payslip_string
      end
    end
  end
  
private

  def self.get_payslip_array(payslip)
    [payslip.name, payslip.pay_period, "#{payslip.gross_income}",\
      "#{payslip.income_tax}","#{payslip.net_income}","#{payslip.super}"]
  end

end
