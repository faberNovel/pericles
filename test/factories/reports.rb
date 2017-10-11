FactoryGirl.define do

  sequence :url_sequence do |n|
    "/users/#{n}"
  end

  factory :report do
    url { generate(:url_sequence) }
    status_code 200
    body '{"user": {"id": 1}}'
    headers {{
      'Content-Length' => 19
    }}
    route
  end
end