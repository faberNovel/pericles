FactoryGirl.define do

  sequence :resource_representation_name do |n|
    "Resource_Representation #{n}"
  end

  factory :resource_representation do
    name { generate(:resource_representation_name) }
    resource
  end
end