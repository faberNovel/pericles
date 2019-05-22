require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  test "shouldn't exist without a status_code" do
    assert_not build(:response, status_code: nil).valid?
  end

  test "shouldn't exist without a route" do
    assert_not build(:response, route: nil).valid?
  end

  test 'json_schema should be nil if response has no resource_representation' do
    assert_nil build(:response, resource_representation: nil).json_schema
  end

  test 'shoud have json_schema if response has resource_representation' do
    assert build(:response, resource_representation: build(:resource_representation)).json_schema
  end

  test 'have a project' do
    assert build(:response).project
  end

  test 'have metadata reflected in json_schema' do
    response = build(:response,
      root_key: 'root',
      resource_representation: build(:resource_representation)
    )
    response.metadata << build(:metadatum, name: 'metadatakey')
    assert response.json_schema[:properties].key? :metadatakey

    response.metadata_responses << build(:metadata_response, metadatum: build(:metadatum, name: 'a'), key: 'key')
    response.metadata_responses << build(:metadata_response, metadatum: build(:metadatum, name: 'b'), key: 'key')

    assert response.json_schema[:properties][:key][:properties].key? :a
    assert response.json_schema[:properties][:key][:properties].key? :b
  end

  test 'mock_picker does not prevent destroy' do
    r = create(:response)
    create(:mock_picker, response: r)

    assert r.destroy
  end

  test 'report does not prevent destroy' do
    r = create(:response)
    create(:report, response: r)

    assert r.destroy
  end

  test 'plain resource representation' do
    assert build(:response).plain_resource_representation?

    refute build(:response, status_code: 400, api_error: create(:api_error)).plain_resource_representation?
    refute build(:response, is_collection: true).plain_resource_representation?
    refute build(:response, root_key: 'root').plain_resource_representation?
    refute build(:response, metadata_responses: [create(:metadata_response)]).plain_resource_representation?
  end
end
