require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should have an email" do
    user = build(:user, email: nil)
    assert_not user.valid?
  end

  test "from_omniauth should return nil if user's email does not end with @applidium.com" do
    access_token = OmniAuth::AuthHash.new

    access_token.info = { email: 'test@example.com' }
    assert_nil User.from_omniauth(access_token)
  end

  test "from_omniauth should not create user if user's email does not end with @applidium.com" do
    access_token = OmniAuth::AuthHash.new

    access_token.info = { email: 'test@example.com' }
    assert_no_difference('User.count') do
      User.from_omniauth(access_token)
    end
  end

  test "from_omniauth should return initialized user if user's email ends with @applidium.com (and user with same email
   does not already exist)" do
    access_token = OmniAuth::AuthHash.new

    access_token.info = { email: 'test@applidium.com', first_name: 'John', last_name: 'Smith',
     image: 'http://example.com/img.jpg' }
    user =  User.from_omniauth(access_token)
    assert user.persisted?
    assert_equal 'test@applidium.com', user.email
    assert_equal 'John', user.first_name
    assert_equal 'Smith', user.last_name
    assert_equal 'http://example.com/img.jpg', user.avatar_url
  end

  test "from_omniauth should create user if user's email ends with @applidium.com (and user with same email
   does not already exist)" do
    access_token = OmniAuth::AuthHash.new

    access_token.info = { email: 'test@applidium.com' }
    assert_difference('User.count') do
      User.from_omniauth(access_token)
    end
  end

  test "from_omniauth should not create user if user's email ends with @applidium.com and user with same email already exists" do
    access_token = OmniAuth::AuthHash.new
    create(:user, email: 'test@applidium.com')

    access_token.info = { email: 'test@applidium.com' }
    assert_no_difference('User.count') do
      User.from_omniauth(access_token)
    end
  end

  test "from_omniauth should return existing user if user's email ends with @applidium.com and user
   with same email already exists" do
    access_token = OmniAuth::AuthHash.new
    create(:user, email: 'test@applidium.com')

    access_token.info = { email: 'test@applidium.com', first_name: 'Chris', last_name: 'Bale' }
    user = User.from_omniauth(access_token)
    assert user.persisted?
    assert_equal 'test@applidium.com', user.email
    assert_equal 'John', user.first_name
    assert_equal 'Smith', user.last_name
  end

  test "from_omniauth should return nil if email is not provided" do
    access_token = OmniAuth::AuthHash.new

    access_token.info = { email: '' }
    user = User.from_omniauth(access_token)
    assert_nil user

    access_token.info = {}
    user = User.from_omniauth(access_token)
    assert_nil user
  end
end
