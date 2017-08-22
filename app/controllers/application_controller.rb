class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to "/not_found"
  end

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end

  def authenticate_user!
    return unless Rails.application.secrets.http_auth_user

    authenticate_or_request_with_http_basic do |u, p|
      u == Rails.application.secrets.http_auth_user &&
      p == Rails.application.secrets.http_auth_password
    end
  end
end
