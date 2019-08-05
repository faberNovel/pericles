require 'test_helper'

class UsersControllerTest < ControllerWithAuthenticationTest
  test 'should get index when internal' do
    get users_path
    assert_response :success
  end

  test 'should not get index when external' do
    @user.update(internal: false)

    get users_path
    assert_response :forbidden
  end

  test 'should show user' do
    get user_path(@user)
    assert_response :success
  end

  test 'should not show user (not authenticated)' do
    sign_out :user
    get user_path(@user)
    assert_redirected_to new_user_session_path
  end

  test 'should update user' do
    assert @user.internal
    patch user_path(@user, format: :json), params: { user: { internal: false } }
    assert_response :success
    assert_not @user.reload.internal
  end

  test 'should not update user when external' do
    @user.update(internal: false)
    patch user_path(@user, format: :json), params: { user: { internal: false } }
    assert_response :forbidden
  end

  test 'should destroy user' do
    delete user_path(@user)
    assert_redirected_to users_path
    assert_not User.exists?(@user.id)
  end

  test 'should not destroy user when external' do
    @user.update(internal: false)
    delete user_path(@user)
    assert_response :forbidden
    assert User.exists?(@user.id)
  end
end
