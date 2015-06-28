require 'spec_helper'
require 'ostruct'
require 'staff'

describe Staff do

  describe '.create' do

    context 'when no import error and no validation error' do

      let(:file) { OpenStruct.new(successful?: true, content: ["David,Rudd,60050,9%,01 March – 31 March",
        "Ryan,Chen,120000,10%,01 March – 31 March"]) }

      before do
        allow(Input::Data).to receive(:import) { file }
        allow(Employee).to receive(:create) { Employee.new }
      end

      it 'assigns an array to list' do
        staff = Staff.create
        expect(staff.list).to be_an(Array)
      end
      it 'assigns list with Employees' do
        staff = Staff.create
        expect(staff.list.first).to be_an_instance_of(Employee)
      end

    end
    context 'when import error' do

      let(:msg)     { ["Input file is blank. Please add employee details to file."] }
      let(:file) { OpenStruct.new(successful?: false, error_message: msg) }
      before { allow(Input::Data).to receive(:import) { file } }

      it 'assigns error to error_message' do
        staff = Staff.create
        expect(staff.import_error).to eq(msg)
      end
      it 'should not assign list' do
        staff = Staff.create
        expect(staff.list).to be_nil
      end

    end

    context 'when validation error' do

      let(:file) { OpenStruct.new(successful?: true, content: ["David,Rudd,-60050,9%,01 March – 31 March"]) }
      let(:msg)     { ["Line 1: Annual salary cannot be negative."] }
      let(:validation) { OpenStruct.new(successful?: false, error_messages: msg) }

      before do
        allow(Input::Data).to receive(:import) { file }
        allow(Input::Validator).to receive(:validate) { validation }
      end

      it 'assigns errors to error_messages' do
        staff = Staff.create
        expect(staff.validation_errors).to eq(msg)
      end
    end

    context 'when one valid and one error' do

      let(:file) { OpenStruct.new(successful?: true, content: ["David,Rudd,-60050,9%,01 March – 31 March", "Ryan,Chen,120000,10%,01 March – 31 March"]) }
      let(:msg) { ["error message"] }
      let(:validation_1) { OpenStruct.new(successful?: false, error_messages: msg) }
      let(:validation_2) { OpenStruct.new(successful?: true) }

      before do
        allow(Input::Data).to receive(:import) { file }
        allow(Input::Validator).to receive(:validate).and_return(validation_1, validation_2)
        allow(Employee).to receive(:create) { 'instance_of_employee'}
      end

      it 'assigns errors to error_messages' do
        staff = Staff.create
        expect(staff.validation_errors).not_to be_nil
      end
      it 'assigns lists to error_messages' do
        staff = Staff.create
        expect(staff.list).not_to be_nil
      end
    end
  end

  describe '#present?' do
    it 'returns true if staff list is present' do
      file = OpenStruct.new(successful?: true, content: ["David,Rudd,60050,9%,01 March – 31 March",
        "Ryan,Chen,120000,10%,01 March – 31 March"])
      allow(Input::Data).to receive(:import) { file }
      allow(Employee).to receive(:create) { Employee.new }

      staff = Staff.create
      expect(staff.present?).to be_truthy
    end
    it 'returns false if staff list is not present' do
      msg = "Input file is blank. Please add employee details to file."
      file = OpenStruct.new(successful?: false, error_message: msg)
      allow(Input::Data).to receive(:import) { file }

      staff = Staff.create
      expect(staff.present?).to be_falsey
    end
  end

end
