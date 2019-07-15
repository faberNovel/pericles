class UsersController < ApplicationController
  include Authenticated

  def index
    authorize User
    @users = policy_scope(User).order(:email)
  end

  def show; end
end
