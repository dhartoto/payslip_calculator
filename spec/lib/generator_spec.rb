require 'spec_helper'
require 'generator'
require 'pry'

describe Generator do

  describe '.new' do
    it 'assigns employees with empty array' do
      allow(Staff).to receive(:create) { [] }
      resp = Generator.new
      expect(resp.staff).to be_an_instance_of(Array)
    end
    it 'assigns employees with empty array' do
      resp = Generator.new
      expect(resp.payslips).to eq([])
    end
    it 'assigns display with nil' do
      resp = Generator.new
      expect(resp.display).to be_nil
    end
  end

  describe '.run' do

    context 'when importing CSV input' do

      let(:file) { double('input_file') }

      context 'when file not present' do
        it 'assigns error message to display' do
          error_message = "Input file is not present. Please save input file into"\
            "the 'Input' folder and try again."
          allow(file).to receive_messages(loaded?: false, error_message: error_message)
          allow(InputFile).to receive(:import) { file }

          resp = PayslipGenerator.run
          msg = "Input file is not present. Please save input file into"\
            "the 'Input' folder and try again."
          expect(resp.display).to eq(msg)
        end
      end
      context 'when file is blank' do
        it 'assigns error message to display' do
          error_message = "File is blank. Please populate input CSV file and try"
          allow(file).to receive_messages(loaded?: false, error_message: error_message)
          allow(InputFile).to receive(:import) { file }

          resp = PayslipGenerator.run
          expect(resp.display).to eq(error_message)
        end
      end
      context 'when no error'
    end
    context 'when exporting CSV output'

  end

end
