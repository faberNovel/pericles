FactoryGirl.define do

  factory :attributes_resource_representation do
    is_required false
    resource_representation
    association :resource_attribute, factory: :attribute
  end
end