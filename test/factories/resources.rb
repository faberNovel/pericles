FactoryGirl.define do

  sequence :resource_name do |n|
    "Resource #{n}"
  end

  factory :resource do
    name { generate(:resource_name) }
    project

    factory :resource_with_attributes do
      transient do
        attribute_count 1
      end
      after(:create) do |resource, evaluator|
        create_list(:attribute, evaluator.attribute_count, parent_resource: resource)
      end
    end
  end

end