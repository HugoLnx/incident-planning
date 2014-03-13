class UserKnowledge
  attr_reader :session
  attr_reader :routing

  def initialize(session, routing)
    @session = session
    @routing = routing
  end
end

RSpec.configure do |c|
  c.before :each, type: :feature do
    @user_knowledge = UserKnowledge.new(page, routing_helpers)
  end
end
