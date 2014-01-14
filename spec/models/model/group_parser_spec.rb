require "spec_helper"

module Model
  describe GroupParser do
    it "can parse a hash with only a group and its name" do
      hash = {"group" => {"name" => "GroupName"}}

      parser = GroupParser.new
      group = parser.parse hash
      expect(group.name).to be == "GroupName"
    end
  end
end
