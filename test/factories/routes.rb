FactoryBot.define do

  sequence :route_url do |n|
    "/users/#{n}"
  end

  factory :route do
    http_method { :GET }
    url { generate(:route_url) }
    resource

    factory :route_with_id do
      http_method { :GET }
      url { '/users/:id' }
      resource
    end

    trait :with_request do
      http_method { :POST }

      after(:build) do |route|
        route.request_resource_representation ||= build(:resource_representation_with_attributes_resource_reps, resource: route.resource)
      end
    end

    trait :with_request_and_required_attributes do
      http_method { :POST }

      after(:build) do |route|
        route.request_resource_representation ||= build(:resource_representation_with_required_attributes_resource_reps, resource: route.resource)
      end
    end
  end
end
