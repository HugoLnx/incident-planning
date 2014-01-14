require 'spec_helper'

module Roles
  describe Parser do
    it 'parse string within each line have the name of role' do
      roles_list_str = %Q{
        Master Chief
        Lower Chief
        Weak Chief
        Ninja Chief
      }

      parser = Parser.new
      roles = parser.parse roles_list_str

      expect(roles[0].name).to be == "Master Chief"
      expect(roles[1].name).to be == "Lower Chief"
      expect(roles[2].name).to be == "Weak Chief"
      expect(roles[3].name).to be == "Ninja Chief"
    end
  end
end
