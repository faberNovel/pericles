FactoryBot.define do

  sequence :mock_profile_name do |n|
    "MockProfile #{n}"
  end

  factory :mock_profile do
    name { generate(:mock_profile_name) }
    project
  end
end
