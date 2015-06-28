require 'spec_helper'
require 'input'

describe Input do

  describe Input::Data do
    describe '.import' do

      context 'csv file and content present' do

        let(:input_data) { "David,Rudd,60050,9%,01 March – 31 March\nRyan,Chen,120000,10%,01 March – 31 March\n" }

        before do
          allow(File).to receive_messages(exists?: true, read: input_data)
        end

        it 'should returns nil for error_message' do
          file = Input::Data.import
          expect(file.error_message).to be_nil
        end
        it 'content should be an Array' do
          file = Input::Data.import
          expect(file.content).to be_an(Array)
        end
        it 'should have same number of employee details as file' do
          file = Input::Data.import
          expect(file.content.count).to eq(2)
        end
        it 'should have same data as file' do
          file = Input::Data.import
          data = "David,Rudd,60050,9%,01 March – 31 March"
          expect(file.content.first).to eq(data)
        end
        it 'responds true to successful?' do
          resp = Input::Data.import
          expect(resp).to be_successful
        end
      end

      context 'file not present' do

        before do
          allow(File).to receive(:exists?) { false }
        end
        it 'responds false to successful?' do
          resp = Input::Data.import
          expect(resp).not_to be_successful
        end
        it 'should have return nil for content' do
          resp = Input::Data.import
          expect(resp.content).to be_nil
        end
        it 'should return error message' do
          resp = Input::Data.import
          msg = "Input file has not been uploaded. Please save input file"\
            " into the 'input' folder."
          expect(resp.error_message).to eq(msg)
        end
      end

      context 'file is blank' do
        before do
          allow(File).to receive_messages(exists?: true, read: '')
        end
        it 'responds false to successful?' do
          resp = Input::Data.import
          expect(resp).not_to be_successful
        end
        it 'should have return nil for content' do
          resp = Input::Data.import
          expect(resp.content).to be_nil
        end
        it 'should return error message' do
          resp = Input::Data.import
          msg = "Input file is blank. Please add employee details to file."
          expect(resp.error_message).to eq(msg)
        end
      end
    end
  end

  describe Input::Validator do

    describe '.validate' do

      context 'when data is valid' do

        let(:data) { "David,Rudd,60050,9%,01 March – 31 March" }

        it 'responds true to successful?' do
          resp = Input::Validator.validate(data, 1)
          expect(resp).to be_successful
        end
      end

      context 'when data does not have 5 employee inputs' do

        let(:data) { "David Rudd,60050,9%,01 March – 31 March" }

        it 'responsds false to successful?' do
          resp = Input::Validator.validate(data, 1)
          expect(resp).not_to be_successful
        end
        it 'assigns error_message' do
          resp = Input::Validator.validate(data, 1)
          msg = "Line 1: Not enough user inputs."
          expect(resp.error_messages).to eq(msg)
        end
      end

      context 'when annual salary is not a positive integer' do

        let(:data) { "David, Rudd,-60050,9%,01 March – 31 March" }

        it 'responds false to successful?' do
          resp = Input::Validator.validate(data, 1)
          expect(resp).not_to be_successful
        end
        it 'assigns error_message' do
          resp = Input::Validator.validate(data, 1)
          msg = ["Line 1: Annual salary cannot be negative."]
          expect(resp.error_messages).to eq(msg)
        end
      end
      context 'when super rate is not within 0% to 50% (inclusive)' do

        it 'responds false to successful?' do
          data = "David, Rudd,60050,51%,01 March – 31 March"
          resp = Input::Validator.validate(data, 1)
          expect(resp).not_to be_successful
        end
        it 'assigns error_message when above 50%' do
          data = "David, Rudd,60050,51%,01 March – 31 March"
          resp = Input::Validator.validate(data, 1)
          msg = ["Line 1: Super rate has to be between 0% and 50% (inclusive)."]
          expect(resp.error_messages).to eq(msg)
        end
        it 'assigns error_message when below 0%' do
          data = "David, Rudd,60050,-1%,01 March – 31 March"
          resp = Input::Validator.validate(data, 1)
          msg = ["Line 1: Super rate has to be between 0% and 50% (inclusive)."]
          expect(resp.error_messages).to eq(msg)
        end
      end
      context 'when multiple errors on one line' do
        it 'returns multiple errors' do
          data = "David, Rudd,-60050,-1%,01 March – 31 March"
          resp = Input::Validator.validate(data, 1)
          msg = ["Line 1: Annual salary cannot be negative.",\
            "Line 1: Super rate has to be between 0% and 50% (inclusive)."]
          expect(resp.error_messages).to eq(msg)
        end
      end
    end
  end
end
