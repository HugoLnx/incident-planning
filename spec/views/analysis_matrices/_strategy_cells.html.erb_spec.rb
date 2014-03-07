require 'spec_helper'

describe "analysis_matrices/_strategy_cells.html.erb" do
  def build_locals(new_locals)
    {
      texts: {name: "Value"},
      update_path: "/path/to/update",
      delete_path: "/path/to/delete",
      repeated: false
    }.merge(new_locals)
  end

  specify "doesn't have whitespaces around text, because the whitespaces confuse javascript when extracting data" do
    render partial: "strategy_cells",
      locals: build_locals(texts: {somename: "TheText"})

    expect(rendered).to match />TheText</
  end
end
