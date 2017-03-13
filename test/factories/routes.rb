FactoryGirl.define do

  sequence :route_name do |n|
    "Route #{n}"
  end

  sequence :route_url do |n|
    "/users/#{n}"
  end

  factory :route do
    name { generate(:route_name) }
    http_method :GET
    url { generate(:route_url) }
    resource
  end
end