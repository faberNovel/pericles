FactoryBot.define do
  factory :api_gateway_integration do
    title 'api title'
    uri_prefix 'prefix'
    timeout_in_millis 29000
    project
  end
end
