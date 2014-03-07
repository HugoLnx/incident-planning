require 'spec_helper'

module Roles
  describe Parser, "parse string within each line have a role" do
    before :each do
      roles_list_str = %Q{
        00: Master Chief
        02: Lower Chief
        04: Weak Chief
        05: Ninja Chief
      }

      parser = Parser.new
      @roles = parser.parse roles_list_str
    end

    it 'parse the name of role' do
      expect(@roles[0].name).to be == "Master Chief"
      expect(@roles[1].name).to be == "Lower Chief"
      expect(@roles[2].name).to be == "Weak Chief"
      expect(@roles[3].name).to be == "Ninja Chief"
    end

    it 'parse the id of role' do
      expect(@roles[0].id).to be == 0
      expect(@roles[1].id).to be == 2
      expect(@roles[2].id).to be == 4
      expect(@roles[3].id).to be == 5
    end
  end
end
