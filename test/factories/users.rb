FactoryGirl.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email { generate(:email) }
    password Devise.friendly_token[0,20]
    first_name 'John'
    last_name 'Smith'
  end
end
