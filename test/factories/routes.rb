FactoryBot.define do

  sequence :route_url do |n|
    "/users/#{n}"
  end

  factory :route do
    http_method :GET
    url { generate(:route_url) }
    resource

    factory :route_with_id do
      http_method :GET
      url '/users/:id'
      resource
    end
  end
end