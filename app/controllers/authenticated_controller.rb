class AuthenticatedController < ApplicationController
  include Pundit
  # TODO: Enable when all controllers Pundited
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  before_action :authenticate_user!
end
