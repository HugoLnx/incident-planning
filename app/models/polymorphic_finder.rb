module PolymorphicFinder
  extend self

  def find(id, type)
    type.constantize.find id
  end
end
