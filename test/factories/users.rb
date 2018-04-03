FactoryBot.define do

  sequence :email do |n|
    "person#{n}#{User::INTERNAL_EMAIL_DOMAIN}"
  end

  sequence :external_email do |n|
    "person#{n}@external.com"
  end

  factory :user do
    email { generate(:email) }
    password Devise.friendly_token[0,20]
    first_name 'John'
    last_name 'Smith'

    trait :external do
      email { generate(:external_email) }
    end
  end
end
