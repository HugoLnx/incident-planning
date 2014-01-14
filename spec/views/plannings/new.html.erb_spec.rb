require 'spec_helper'

describe "plannings/new" do
  before(:each) do
    assign(:planning, stub_model(Planning,
      :incident_name => "MyString",
      :priorities_list => "MyText",
      :cycle => 1
    ).as_new_record)
  end

  it "renders new planning form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", plannings_path, "post" do
      assert_select "input#planning_incident_name[name=?]", "planning[incident_name]"
      assert_select "textarea#planning_priorities_list[name=?]", "planning[priorities_list]"
      assert_select "input#planning_cycle[name=?]", "planning[cycle]"
    end
  end
end
