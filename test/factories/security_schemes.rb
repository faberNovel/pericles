FactoryBot.define do
  sequence :security_scheme_key do |n|
    "theUltimateSecurity#{n}"
  end

  factory :security_scheme do
    key { generate(:security_scheme_key) }
    security_scheme_type "apiKey"
    name "Authorization"
    security_scheme_in "header"
    specification_extensions "{\"x-amazon-apigateway-authtype\": \"cognito_user_pools\"}"
    project
  end
end
