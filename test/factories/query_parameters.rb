FactoryGirl.define do

  sequence :query_parameter_name do |n|
    "QueryParameter #{n}"
  end

  factory :query_parameter do
    name { generate(:query_parameter_name) }
    primitive_type :integer
    route
  end
end