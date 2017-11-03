class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do
    render file: 'public/404.html', status: :not_found, layout: false
  end

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end
end
