class ReuseFilterCollectionInput < SimpleForm::Inputs::Base
  def input
    out = ''

    value = object.public_send(attribute_name)
    
    opts = {
      collection: options[:collection],
      label_method: (-> (opt){opt[:label]}),
      value_method: (-> (opt){opt[:value]}),
      label: false,
      selected: value,
      include_blank: false
    }
    out << @builder.input(attribute_name, opts)
    out.html_safe
  end
end
