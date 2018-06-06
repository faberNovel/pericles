require 'test_helper'

class SchemesControllerTest < ControllerWithAuthenticationTest
  test 'should show schemes' do
    get schemes_path
    assert_response :success
  end

  test 'should show scheme new form' do
    get new_scheme_path
    assert_response :success
  end

  test 'should create scheme' do
    assert_difference('Scheme.count') do
      post schemes_path, params: { scheme: { name: 'nice name', regexp: '[a-z]+' } }
    end
    assert_redirected_to schemes_path
  end

  test 'should get edit scheme form' do
    scheme = create(:scheme)
    get edit_scheme_path(scheme)
    assert_response :success
  end

  test 'should update scheme' do
    scheme = create(:scheme, name: 'a')
    patch scheme_path(scheme), params: { scheme: { name: 'b' } }
    assert_redirected_to schemes_path
    assert_equal scheme.reload.name, 'b'
  end

  test 'should delete scheme' do
    scheme = create(:scheme)
    assert_difference('Scheme.count', -1) do
      delete scheme_path(scheme)
    end
    assert_redirected_to schemes_path
  end
end
