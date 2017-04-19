FactoryGirl.define do

  sequence :attribute_name do |n|
    "Attribute #{n}"
  end

  factory :attribute do
    name { generate(:attribute_name) }
    association :parent_resource, factory: :resource
    primitive_type :integer

    trait :with_resource do
      primitive_type nil
      resource
    end

    factory :attribute_with_resource, traits: [:with_resource]
  end
end
