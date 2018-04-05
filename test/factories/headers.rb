FactoryBot.define do

  sequence :header_name do |n|
    "Header #{n}"
  end

  factory :header do
    name { generate(:header_name) }
    association :http_message, factory: :route
  end
end