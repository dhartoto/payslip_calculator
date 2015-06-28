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
  end

  describe '#run' do
    let(:staff) { double('staff') }
    before { allow(Staff).to receive(:create) { staff } }

    context 'when staff is present' do
      let(:generator) { Generator.new }
      let(:payslip) { double('payslip') }

      before do
        allow(staff).to receive_messages(present?: true,
          list:  ['staff_1', 'staff_2'],
          validation_errors: [])
        allow(payslip).to receive(:generate) { 'pay_slip' }
        allow(Payslip).to receive(:new) { payslip }
      end
      it 'generates payslips' do
        generator.run
        expect(generator.payslips.count).to eq(2)
      end
      it 'creates output file' do
        expect(OutputFile).to receive(:deliver)
        generator.run
      end

      context 'when no validation error in input file.' do

        it 'assigns completion message with 0 errors' do
          msg = "2 payslip information were generated and delivered to the"\
            " output folder with 0 errors."
          generator.run
          expect(generator.completion_message).to eq(msg)
        end

      end

      context 'when 1 validation error in input file.' do
        it 'assigns completion message with 1 error' do
          allow(staff).to receive(:validation_errors) { ["some error"] }
          msg = "2 payslip information were generated and delivered to the"\
            " output folder with 1 errors."
          generator.run
          expect(generator.completion_message).to eq(msg)
        end
      end

    end

    context 'staff is not present' do
      let(:error_message) { "Input file has not been uploaded. Please save input file"\
        " into the 'input' folder." }
      let(:generator) { Generator.new }
      let(:payslip) { double('payslip') }

        before do
          allow(staff).to receive(:present?).and_return(false, true)
          allow(staff).to receive_messages(
            import_error: error_message,
            list:  ['staff_1', 'staff_2'],
            validation_errors: []
          )
          allow(payslip).to receive(:generate) { 'pay_slip' }
          allow(Payslip).to receive(:new) { payslip }
        end

      it 'assigns error message to display' do
        allow(generator).to receive(:gets) { '1' }
        msg = error_message + "\nEnter '1' to continue or '2' to exit the program."
        generator.run
        expect(generator.error_message).to eq(msg)
      end
      it 'creates staff after user enters cont' do
        allow(generator).to receive(:gets) { '1' }
        expect(Staff).to receive(:create)
        generator.run
      end
      it 'exits with message after user enters exit' do
        allow(generator).to receive(:gets) { '2' }
        msg = "Exiting...Goodbye!"
        resp = lambda{ generator.run }
        expect(resp).to raise_error(SystemExit, msg)
      end
    end
  end

end
