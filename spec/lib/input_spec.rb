require 'spec_helper'
require 'input'

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
        msg = "Input file has not been uploaded. Please save your file"\
          " in the 'input' folder, type 'cont' then click enter."
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
        msg = "Input file is blank. Please add employee details to file, type"\
         " 'cont' then click enter."
        expect(resp.error_message).to eq(msg)
      end

    end

  end

end
