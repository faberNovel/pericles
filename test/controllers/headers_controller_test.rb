require 'test_helper'

class HeadersControllerTest < ActionDispatch::IntegrationTest
  setup do
    create(:header, name: "Accept")
    create(:header, name: "Accept")
    create(:header, name: "accept")
    create(:header, name: "Content-Type")
  end

  test "Should return list of headers (with distinct names) matching the search term" do
    get "/headers", params: { term: "a" }, headers: { 'Accept' => 'application/json' }
    assert_equal 2, JSON.parse(@response.body)["headers"].size
    assert_response :ok

    get "/headers", params: { term: "x" }, headers: { 'Accept' => 'application/json' }
    assert_equal 0, JSON.parse(@response.body)["headers"].size
    assert_response :ok
  end

  test "Should return list of all headers (with distinct names)" do
    get "/headers", headers: { 'Accept' => 'application/json' }
    assert_equal 3, JSON.parse(@response.body)["headers"].size
    assert_response :ok
  end
end
