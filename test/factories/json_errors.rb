FactoryGirl.define do

  factory :json_error do
    description 'error'
    validation

    factory :json_instance_error do
      type "JsonInstanceError"
    end

    factory :json_schema_error do
      type "JsonSchemaError"
    end
  end
end
