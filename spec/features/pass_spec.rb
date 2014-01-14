require 'spec_helper'

feature "Will Pass" do
  it 'pass without js' do
    expect(true).to be_true
  end

  it 'pass with js', :js do
    expect(true).to be_true
  end
end
