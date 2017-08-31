require 'test_helper'

class HeadersControllerTest < ControllerWithAuthenticationTest
  setup do
    create(:header, name: "Accept")
    create(:header, name: "Accept")
    create(:header, name: "accept")
    create(:header, name: "Content-Type")
  end

  test "Should return list of headers (with distinct names) matching the search term" do
    get "/headers", params: { term: "a" }, headers: { 'Accept' => 'application/json' }
    assert_equal 2, JSON.parse(response.body)["headers"].size
    assert_response :ok

    get "/headers", params: { term: "x" }, headers: { 'Accept' => 'application/json' }
    assert_equal 0, JSON.parse(response.body)["headers"].size
    assert_response :ok
  end

  test "Should return list of all headers (with distinct names)" do
    get "/headers", headers: { 'Accept' => 'application/json' }
    assert_equal 3, JSON.parse(response.body)["headers"].size
    assert_response :ok
  end

  test "Should not return list of all headers (with distinct names) (not authenticated)" do
    sign_out :user
    get "/headers", headers: { 'Accept' => 'application/json' }
    assert_response :unauthorized
    response_body = JSON.parse(response.body)
    assert_nil response_body["headers"]
    assert_equal "You need to sign in or sign up before continuing.", response_body["error"]
  end
end
