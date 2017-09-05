class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user&.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:alert] = I18n.t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: I18n.t('users.sign_in.check_domain')
      redirect_to new_user_session_path
    end
  end
end
