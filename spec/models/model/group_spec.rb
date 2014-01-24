require 'spec_helper'

module Model
  describe Group do
    it "know your ancestors" do
      grandfather = build(:model_group, name: "Grandfather")
      father = build(:model_group, name: "Father")
      child = build(:model_group, name: "Child")

      child.father = father
      father.father = grandfather

      expect(child.ancestors).to be == [father, grandfather]
    end

    it "know your path based on your ancestors names" do
      grandfather = build(:model_group, name: "Grandfather")
      father = build(:model_group, name: "Father")
      child = build(:model_group, name: "Child")

      child.father = father
      father.father = grandfather

      expect(child.path).to be == "Grandfather/Father/Child"
    end
  end
end
