class AuditsController < ApplicationController
  include Authenticated
  include ProjectRelated

  def index
    @audits = AuditsRepository.new
               .news_of_project(project)
               .page(params[:page]).per(200)
  end

  def slack_post
    news_posted_count = PostSlackNews.new(project).execute
    redirect_to project_audits_path(project), notice: t('.news_posted_on', news_posted_count: news_posted_count, slack_channel: project.slack_channel)
  end
end
