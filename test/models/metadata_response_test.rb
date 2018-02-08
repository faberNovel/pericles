require 'test_helper'

class MetadataResponseTest < ActiveSupport::TestCase
  test "shouldn't exist without a metadatum" do
    assert_not build(:metadata_response, metadatum: nil).valid?
  end

  test "shouldn't exist without a response" do
    assert_not build(:metadata_response, response: nil).valid?
  end

  test "couple metadatum/response should be unique" do
    metadata_response = create(:metadata_response)

    assert_not build(:metadata_response,
      metadatum: metadata_response.metadatum,
      response: metadata_response.response
    ).valid?
  end
end
