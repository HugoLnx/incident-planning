require 'spec_helper'

describe "plannings/index" do
  before(:each) do
    assign(:plannings, [
      stub_model(Planning,
        :incident_name => "Incident Name",
        :priorities_list => "MyText",
        :cycle => 1
      ),
      stub_model(Planning,
        :incident_name => "Incident Name",
        :priorities_list => "MyText",
        :cycle => 1
      )
    ])
  end

  it "renders a list of plannings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Incident Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
