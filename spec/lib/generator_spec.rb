require 'spec_helper'
require 'generator'

describe Generator do

  describe '.new' do

    before { allow(Staff).to receive(:create) { [] } }

    it 'assigns employees with empty array' do
      resp = Generator.new
      expect(resp.staff).to be_an_instance_of(Array)
    end
    it 'assigns employees with empty array' do
      resp = Generator.new
      expect(resp.payslips).to eq([])
    end
    it 'assigns error_message with nil' do
      resp = Generator.new
      expect(resp.error_message).to be_nil
    end
    it 'assigns success_message' do
      msg = "Payslips have been generated and may be retreived from the 'output' folder."
      resp = Generator.new
      expect(resp.success_message).to eq(msg)
    end
  end

  describe '#run' do

    let(:staff) { double('staff') }
    before { allow(Staff).to receive(:create) { staff } }

    context 'when staff is present' do

      let(:generator) { Generator.new }

      before do
        allow(staff).to receive_messages(present?: true, list:  ['staff_1', 'staff_2'])
        allow(Payslip).to receive(:generate) { 'pay_slip' }
      end

      it 'generates payslips' do
        generator.run
        expect(generator.payslips.count).to eq(2)
      end
      it 'creates output file' do
        expect(OutputFile).to receive(:deliver)
        generator.run
      end
    end

    context 'staff is not present' do

      let(:error_message) { "Input file has not been uploaded. Please save your file"\
        " in the 'Input' folder, type 'cont' then click enter." }
      let(:generator) { Generator.new }

        before do
          allow(staff).to receive(:present?).and_return(false, true)
          allow(staff).to receive_messages(
            error_message: error_message,
            list:  ['staff_1', 'staff_2']
          )
        end

      it 'assigns error message to display' do
        allow(generator).to receive(:gets) { 'cont' }
        msg = error_message + "\nOr type 'exit' and hit 'Enter' to exit the program."

        generator.run

        expect(generator.error_message).to eq(msg)
      end
      it 'creates staff after user enters cont' do
        allow(generator).to receive(:gets) { 'cont' }
        expect(Staff).to receive(:create)
        generator.run
      end
      it 'exits with message after user enters exit' do
        allow(generator).to receive(:gets) { 'exit' }
        msg = "Exiting...Goodbye!"
        resp = lambda{ generator.run }
        expect(resp).to raise_error(SystemExit, msg)
      end
    end
  end

end
