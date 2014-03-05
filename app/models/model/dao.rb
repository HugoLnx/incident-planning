module Model
  class Dao
    JSON_PATH = "config/model.json"

    def initialize
      @group_parser = GroupParser.new ExpressionParser.new
      @json_parser = ActiveSupport::JSON
      @path = JSON_PATH
    end

    def root_group
      hash = @json_parser.decode json
      @group_parser.parse hash
    end

    def json
      File.read @path
    end
  end
end
