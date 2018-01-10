class ApplicationController < ActionController::Base
  include Pundit

  rescue_from ActiveRecord::RecordNotFound do
    render file: 'public/404.html', status: :not_found, layout: false
  end

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  def user
    @user ||= current_user.decorate
  end
  helper_method :user
end
