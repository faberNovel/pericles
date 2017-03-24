class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do
    redirect_to "/not_found"
  end

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end
end
