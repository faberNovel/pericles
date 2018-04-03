FactoryBot.define do

  sequence :resource_name do |n|
    "Resource #{n}"
  end

  factory :resource do
    name { generate(:resource_name) }
    project

    factory :resource_with_attributes do
      after(:create) do |resource, _|
        resource.resource_attributes << create(:attribute) << create(:attribute_with_resource)
      end
    end

    factory :pokemon do
      name 'Pokemon'
      project { create(:project, title: 'PokeApi') }

      after(:create) do |resource, _|
        resource.resource_attributes << create(:attribute, name: 'id', primitive_type: :integer)
        resource.resource_attributes << create(:attribute, name: 'weight', primitive_type: :number, nullable: true)
        resource.resource_attributes << create(:attribute_with_resource, name: 'weakness_list', resource: create(:resource, name: 'nature'), is_array: true)
        resource.resource_attributes << create(:attribute, name: 'date', primitive_type: :date, nullable: false)
        resource.resource_attributes << create(:attribute, name: 'date_time', primitive_type: :datetime, nullable: true)

        resource.resource_attributes.each do |a|
          create(:attributes_resource_representation,
            resource_attribute: a,
            parent_resource_representation: resource.default_representation,
            resource_representation: a.resource&.default_representation,
            is_required: true
          )
        end

        # This attribute is not nullable but is not in default representation
        resource.resource_attributes << create(:attribute, name: 'niceBoolean', primitive_type: :boolean)
      end
    end
  end

end