FactoryGirl.define do

  sequence :resource_name do |n|
    "Resource #{n}"
  end

  factory :resource do
    name { generate(:resource_name) }
    project
  end

end