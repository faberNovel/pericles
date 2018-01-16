class ApplicationController < ActionController::Base
  include Pundit
  include Lazy

  rescue_from ActiveRecord::RecordNotFound do
    render file: 'public/404.html', status: :not_found, layout: false
  end

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  rescue_from Pundit::NotAuthorizedError do
    if current_user
      render file: 'public/403.html', status: :forbidden, layout: false
    else
      redirect_to new_user_session_path
    end
  end

  def user
    @user ||= UserDecorator.new(current_user)
  end
  helper_method :user
end
