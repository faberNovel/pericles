require 'test_helper'

class ControllerWithAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    sign_in @user
  end
end