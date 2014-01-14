require 'spec_helper'

describe "plannings/edit" do
  before(:each) do
    @planning = assign(:planning, stub_model(Planning,
      :incident_name => "MyString",
      :priorities_list => "MyText",
      :cycle => 1
    ))
  end

  it "renders the edit planning form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", planning_path(@planning), "post" do
      assert_select "input#planning_incident_name[name=?]", "planning[incident_name]"
      assert_select "textarea#planning_priorities_list[name=?]", "planning[priorities_list]"
      assert_select "input#planning_cycle[name=?]", "planning[cycle]"
    end
  end
end
