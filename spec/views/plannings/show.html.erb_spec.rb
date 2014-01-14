require 'spec_helper'

describe "plannings/show" do
  before(:each) do
    @planning = assign(:planning, stub_model(Planning,
      :incident_name => "Incident Name",
      :priorities_list => "MyText",
      :cycle => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Incident Name/)
    rendered.should match(/MyText/)
    rendered.should match(/1/)
  end
end
