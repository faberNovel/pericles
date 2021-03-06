require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user should have an email' do
    user = build(:user, email: nil)
    assert_not user.valid?
  end

  test 'from_omniauth should return initialized user if user with same email does not already exist' do
    access_token = OmniAuth::AuthHash.new

    access_token.info = {
      email: "test#{User::INTERNAL_EMAIL_DOMAIN}",
      first_name: 'John',
      last_name: 'Smith',
      image: 'http://example.com/img.jpg'
    }

    user = User.from_omniauth(access_token)
    assert user.persisted?
    assert_equal "test#{User::INTERNAL_EMAIL_DOMAIN}", user.email
    assert_equal 'John', user.first_name
    assert_equal 'Smith', user.last_name
    assert_equal 'http://example.com/img.jpg', user.avatar_url
  end

  test 'from_omniauth should create user if user with same email does not already exist' do
    access_token = OmniAuth::AuthHash.new

    access_token.info = { email: "test#{User::INTERNAL_EMAIL_DOMAIN}" }
    assert_difference('User.count') do
      User.from_omniauth(access_token)
    end
  end

  test 'from_omniauth should not create user if user with same email already exists' do
    access_token = OmniAuth::AuthHash.new
    create(:user, email: "test#{User::INTERNAL_EMAIL_DOMAIN}")

    access_token.info = { email: "test#{User::INTERNAL_EMAIL_DOMAIN}" }
    assert_no_difference('User.count') do
      User.from_omniauth(access_token)
    end
  end

  test 'from_omniauth should return existing user if user with same email already exists' do
    access_token = OmniAuth::AuthHash.new
    create(:user, email: "test#{User::INTERNAL_EMAIL_DOMAIN}")

    access_token.info = { email: "test#{User::INTERNAL_EMAIL_DOMAIN}", first_name: 'Chris', last_name: 'Bale' }
    user = User.from_omniauth(access_token)
    assert user.persisted?
    assert_equal "test#{User::INTERNAL_EMAIL_DOMAIN}", user.email
    assert_equal 'John', user.first_name
    assert_equal 'Smith', user.last_name
  end

  test 'from_omniauth should return nil if email is not provided' do
    access_token = OmniAuth::AuthHash.new

    access_token.info = { email: '' }
    user = User.from_omniauth(access_token)
    assert_nil user

    access_token.info = {}
    user = User.from_omniauth(access_token)
    assert_nil user
  end

  test 'set internal when email domain is INTERNAL_EMAIL_DOMAIN' do
    assert build(:user, email: "test#{User::INTERNAL_EMAIL_DOMAIN}").set_internal_from_domain
  end

  test 'does not set internal when email domain is not INTERNAL_EMAIL_DOMAIN' do
    refute build(:user, email: 'test@external.com').set_internal_from_domain
  end

  test 'set internal when first user' do
    assert build(:user, email: 'test@external.com').set_internal_when_first

    create(:user)
    refute build(:user, email: 'test@external.com').set_internal_when_first
  end
end
