FactoryGirl.define do

  factory :mock_picker do
    mock_profile
    response
    response_is_favorite false
  end
end
