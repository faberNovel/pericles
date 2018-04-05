FactoryBot.define do

  sequence :url_sequence do |n|
    "/users/#{n}"
  end

  factory :report do
    url { generate(:url_sequence) }
    response_status_code 200
    response_body '{"user": {"id": 1}}'
    response_headers {{
      'Content-Length' => 19
    }}
    request_body '{}'
    request_headers {{
      'Accept-Encoding' => 'gzip'
    }}
    route
    project
    response
  end
end