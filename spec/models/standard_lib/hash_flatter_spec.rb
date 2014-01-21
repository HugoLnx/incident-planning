require 'spec_helper'

describe StandardLib::HashFlatter do
  it 'flatten params with format "prefix(\di)"' do
    hash_flatter = StandardLib::HashFlatter.new({
      "sum(1i)" => 5,
      "sum(2i)" => 3,
      "sum(3i)" => 2
    })

    hash_flatter.flatten "sum" do |values|
      values.inject(:+)
    end

    hash = hash_flatter.hash
    
    expect(hash).to be == {"sum" => 10}
  end

  context "if prefix doesn't exist" do
    it "doesn't do nothing" do
      hash_flatter = StandardLib::HashFlatter.new(
        {"hey" => "somevalue"}
      )

      hash_flatter.flatten("hey") {|values| nil}

      hash = hash_flatter.hash

      expect(hash).to be == {"hey" => "somevalue"}
    end
  end
end
