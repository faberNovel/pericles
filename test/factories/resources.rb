FactoryGirl.define do

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
  end

end