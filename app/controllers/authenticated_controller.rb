class AuthenticatedController < ApplicationController
  # TODO: Enable when all controllers Pundited
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError do
    render file: 'public/403.html', status: :forbidden, layout: false
  end
end
