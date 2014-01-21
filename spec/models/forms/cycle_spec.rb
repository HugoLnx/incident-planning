require 'spec_helper'

describe Forms::Cycle do
  it_behaves_like "ActiveModel"

  pending "validates 'from' and 'to' attributes"
  pending "passes 'from' and 'to' form values to cycle attributes values"
end
