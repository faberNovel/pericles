FactoryGirl.define do

  sequence :resource_representation_name do |n|
    "Resource_Representation #{n}"
  end

  factory :resource_representation do
    name { generate(:resource_representation_name) }
    resource

    factory :resource_representation_with_attributes_resource_reps do

      association :resource, factory: :resource_with_attributes

      after(:build) do |resource_representation, _evaluator|
        resource_representation.resource.resource_attributes.each do |attribute|
          resource_representation.attributes_resource_representations << build(:attributes_resource_representation, resource_attribute: attribute,
            resource_representation: resource_representation)
        end
      end
    end
  end
end