class InstancesController < ApplicationController
  include Authenticated

  def create
    render json: GenerateJsonInstanceService.new(params[:schema]).execute
  end
end
