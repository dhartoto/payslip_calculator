require 'spec_helper'
require 'ostruct'
require 'output_file'

describe OutputFile do

  let(:payslip_david) do
    OpenStruct.new(name: 'David Rudd',
      pay_period: "01 March – 31 March",
      gross_income: 5004,
      income_tax: 922,
      net_income: 4082,
      super: 450)
  end
  let(:payslip_ryan) do
    OpenStruct.new(name: 'Ryan Chen',
      pay_period: "01 March – 31 March",
      gross_income: 10000,
      income_tax: 2696,
      net_income: 7304,
      super: 1000)
  end
  let(:generator) { OpenStruct.new(list: [payslip_david, payslip_ryan]) }

  after { File.delete('output/payslip_information.csv')}

  describe '.deliver' do
    it 'creates payslip_information.csv' do
      OutputFile.deliver(generator)
      file_exist = File.exist?("output/payslip_information.csv")
      expect(file_exist).to eq(true)
    end
    it 'writes to csv file' do
      OutputFile.deliver(generator)
      generated_output = File.read('output/payslip_information.csv')
      expected_output = "David Rudd,01 March – 31 March,5004,922,4082,450\nRyan"\
        " Chen,01 March – 31 March,10000,2696,7304,1000\n"
      expect(generated_output).to eq(expected_output)

    end
  end

end
