require 'test_helper'

class SchemesControllerTest < ControllerWithAuthenticationTest

  test "should show schemes" do
    get schemes_path
    assert_response :success
  end

  test "should show scheme new form" do
    get new_scheme_path
    assert_response :success
  end

  test "should create scheme" do
    assert_difference('Scheme.count') do
      post schemes_path, params: { scheme: { name: 'nice name', regexp: '[a-z]+' } }
    end
    assert_redirected_to schemes_path
  end

  test "should delete scheme" do
    scheme = Scheme.create(name: 'nice name', regexp: '[a-z]+')
    assert_difference('Scheme.count', -1) do
      delete scheme_path(scheme)
    end
    assert_redirected_to schemes_path
  end
end