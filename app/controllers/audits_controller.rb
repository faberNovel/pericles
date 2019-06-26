class AuditsController < ApplicationController
  include Authenticated
  include ProjectRelated

  def index
    @audits = AuditsRepository.new
               .news_of_project(project)
               .page(params[:page]).per(200)
  end
end
