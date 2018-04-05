FactoryBot.define do

  factory :proxy_configuration do
    project
    target_base_url 'https://api-develop.herokuapp.com'
  end
end
