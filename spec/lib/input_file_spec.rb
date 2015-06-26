require 'spec_helper'
require 'input_file'
require 'pry'

describe InputFile do

  describe '.import' do

    context 'csv file and content present' do
      let(:input_data) { "David,Rudd,60050,9%,01 March – 31 March\nRyan,Chen,120000,10%,01 March – 31 March\n" }
      before do
        # allow(File).to receive_messages(input_data: input_data)
      end

      it 'should returns nil for error_message' do
        file = InputFile.import
        expect(file.error_message).to be_nil
      end
      it 'content should be an Array' do
        file = InputFile.import
        expect(file.content).to be_an(Array)
      end
      it 'should have same number of employee details as file' do
        file = InputFile.import
        expect(file.content.count).to eq(2)
      end
      it 'should have same data as file' do
        file = InputFile.import
        data = "David,Rudd,60050,9%,01 March – 31 March"
        expect(file.content.first).to eq(data)
      end
      it 'responds true to successful?' do
        resp = InputFile.import
        expect(resp).to be_successful
      end
    end

    context 'file not present' do

      before do
        allow(File).to receive(:present?) { false }
      end
      it 'responds false to successful?' do
        resp = InputFile.import
        expect(resp).to be_successful
      end

    end

  end


end
