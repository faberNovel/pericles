class ApplicationController < ActionController::Base
  if Rails.application.secrets.http_auth_user
    http_basic_authenticate_with name: Rails.application.secrets.http_auth_user, password: Rails.application.secrets.http_auth_password
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to "/not_found"
  end

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end
end
