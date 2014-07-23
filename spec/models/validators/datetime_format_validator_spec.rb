require 'spec_helper'

describe DatetimeFormatValidator, "validates using datetime format" do
  describe "validations with format '%H:%M'" do
    context "considers valid if minutes are a number between 0-59" do
      before :all do
        @TmpModel = Class.new do
          include ActiveModel::Model

          def self.name
            "TmpModel"
          end

          validates :time, datetime_format: {with: "%H:%M"}

          attr_accessor :time
        end
      end

      specify "00:60 is invalid" do
        model = @TmpModel.new(time: "00:60")
        expect(model).to_not be_valid
      end

      specify "00:59 is valid" do
        model = @TmpModel.new(time: "00:59")
        expect(model).to be_valid
      end
    end
  end
end
