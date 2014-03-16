class RolesCollectionInput < SimpleForm::Inputs::Base
  def input
    out = ''

    ids = object.public_send(attribute_name)
    [ids.size, 3].max.times do |i|
      role_id = ids[i]
      opts = {
        collection: options[:available_roles],
        label_method: :name,
        value_method: :id,
        label: false,
        selected: role_id,
        include_blank: true,
        input_html: {
          name: "user[roles_ids][]"
        }
      }
      out << @builder.input(attribute_name, opts)
    end
    out.html_safe
  end

  def label
    "Roles"
  end
end
