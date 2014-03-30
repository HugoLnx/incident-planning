require 'spec_helper'

describe ApprovalCollection, "represent approvals to be saved" do
  describe "when saving" do
    context "saves each approval if them all are valid" do
      it "saves two approvals because collection are composed of two valid approvals" do
        collection = ApprovalCollection.new build_list(:approval, 2)

        expect(collection.save).to be == true
        expect(collection[0]).to be_persisted
        expect(collection[1]).to be_persisted
      end
    end

    context "saves nothing if exist one invalid" do
      it "saves none approvals because all approvals are invalid" do
        invalid_approvals = build_list(:approval, 2)
        invalid_saving = InvalidSavingStubber.new(self)
        invalid_saving.stub_all invalid_approvals

        collection = ApprovalCollection.new invalid_approvals

        expect(collection.save).to be == false
        expect(collection[0]).not_to be_persisted
        expect(collection[1]).not_to be_persisted
      end
      
      it "saves none approvals because first of two approvals is invalid" do
        invalid_approvals = build_list(:approval, 2)
        invalid_saving = InvalidSavingStubber.new(self)
        invalid_saving.stub invalid_approvals[0]

        collection = ApprovalCollection.new invalid_approvals

        expect(collection.save).to be == false
        expect(collection[0]).not_to be_persisted
        expect(collection[1]).not_to be_persisted
      end
    end
  end
end
