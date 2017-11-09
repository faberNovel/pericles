FactoryGirl.define do

  sequence :mock_name do |n|
    "Mock #{n}"
  end

  factory :mock_instance do
    name { generate(:mock_name) }
    body '{}'
    resource
  end
end
