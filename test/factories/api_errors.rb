FactoryBot.define do
  sequence :api_error_name do |n|
    "API Error #{n}"
  end

  factory :api_error do
    name { generate(:api_error_name) }
    json_schema '{}'
    project
  end
end
