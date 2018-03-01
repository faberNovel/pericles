FactoryGirl.define do

  factory :validation_error do
    category :header
    description 'Content-Type is missing from the response headers'
  end
end