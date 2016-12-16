FactoryGirl.define do

  sequence :json_schema_name do |n|
    "Json_schema #{n}"
  end

  factory :json_schema do
    name { generate(:json_schema_name) }
    schema '{ }'
    project
  end

end