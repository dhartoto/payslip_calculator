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
        allow(OutputFile).to receive(:deliver)
        generator.run
        expect(generator.payslips.count).to eq(2)
      end
      it 'creates output file' do
        expect(OutputFile).to receive(:deliver)
        generator.run
      end

      context 'when no validation error in input file.' do

        it 'assigns completion message with 0 errors' do
          allow(OutputFile).to receive(:deliver)
          msg = "2 payslips were generated and delivered to the"\
            " output folder with 0 errors."
          generator.run
          expect(generator.completion_message).to eq(msg)
        end

      end

      context 'when 1 validation error in input file.' do
        it 'assigns completion message with 1 error' do
          allow(OutputFile).to receive(:deliver)
          allow(staff).to receive(:validation_errors) { ["some error"] }
          msg = "2 payslips were generated and delivered to the"\
            " output folder with 1 errors."
          generator.run
          expect(generator.completion_message).to eq(msg)
        end
      end

    end
    
  end

end
