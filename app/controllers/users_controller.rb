class UsersController < ApplicationController
  include Authenticated

  lazy_controller_of :user

  def index
    authorize User
    @users = policy_scope(User).order(:email)
  end

  def update
    if user.update(permitted_attributes(user))
      respond_to do |format|
        format.json { render json: user }
      end
    else
      respond_to do |format|
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if user.destroy
      redirect_to users_path, notice: "#{user.email} has been deleted."
    else
      redirect_to users_path, alert: users_path.errors.full_messages
    end
  end

  def show; end
end
