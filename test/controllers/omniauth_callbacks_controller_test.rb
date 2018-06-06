require 'test_helper'

class OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
  end

  test 'redirect if user is found' do
    User.stub :from_omniauth, create(:user) do
      post user_google_oauth2_omniauth_callback_path
      assert_redirected_to root_path
    end
  end

  test 'redirect to new_session if user is not found' do
    User.stub :from_omniauth, nil do
      post user_google_oauth2_omniauth_callback_path
      assert_redirected_to new_user_session_path
    end
  end
end
