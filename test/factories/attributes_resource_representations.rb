FactoryBot.define do

  factory :attributes_resource_representation do
    is_required false
    is_null false
    association :parent_resource_representation, factory: :resource_representation
    association :resource_attribute, factory: :attribute
    custom_key_name nil
  end

  trait :is_required do
    is_required true
  end
end