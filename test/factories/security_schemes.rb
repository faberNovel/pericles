FactoryBot.define do

  factory :security_scheme do
    key "theUltimateSecurity"
    security_scheme_type "apiKey"
    name "Authorization"
    security_scheme_in "header"
    parameters "{\"x-amazon-apigateway-authtype\": \"cognito_user_pools\"}"
    project
  end
end
