FactoryGirl.define do

  sequence :email do |n|
    "person#{n}#{User::INTERNAL_EMAIL_DOMAIN}"
  end

  factory :user do
    email { generate(:email) }
    password Devise.friendly_token[0,20]
    first_name 'John'
    last_name 'Smith'
  end
end
