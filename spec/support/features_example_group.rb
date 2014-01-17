module FeaturesExampleGroup
  extend ActiveSupport::Concern

  FILE_PATH = %r(spec/features)

  included do
    metadata[:type] = :feature
  end

  RSpec.configure do |config|
    config.include FeaturesExampleGroup, :example_group => { :file_path => FILE_PATH }
  end
end
