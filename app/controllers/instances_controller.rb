class InstancesController < ApplicationController
  def create
    render json: GenerateJsonInstanceService.new(params[:schema]).execute
  end
end
