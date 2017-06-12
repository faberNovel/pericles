class RemoveIsRequiredFromAttributes < ActiveRecord::Migration[5.0]
  def up
    Resource.all.each do |resource|
      default_resource_rep = resource.resource_representations.build(name: "default_representation", description: "Automatically generated")

      if default_resource_rep.save
        resource.resource_attributes.each do |attribute|
          default_resource_rep.attributes_resource_representations.create(resource_attribute: attribute, is_required: attribute.is_required)
        end
      end
    end

    remove_column :attributes, :is_required, :boolean
  end

  def down
    add_column :attributes, :is_required, :boolean, null: false, default: false

    Resource.all.each do |resource|
      default_resource_rep = resource.resource_representations.find_by_name("default_representation")

      if default_resource_rep
        default_resource_rep.attributes_resource_representations.each do |attr_res_rep|
          attribute = attr_res_rep.resource_attribute
          attribute.is_required = attr_res_rep.is_required
          attribute.save
        end
        default_resource_rep.destroy
      end
    end
  end

end
