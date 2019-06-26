class PostSlackNews
  def initialize(project)
    @project = project
    @attachment_mapper = SlackAttachmentMapper.new
  end

  def execute(since = @project.slack_updated_at)
    since ||= 1.day.ago
    audits = AuditsRepository.new
      .news_of_project(@project)
      .where('created_at > ?', since)
      .map(&:decorate)

    return 0 if audits.empty?

    attachments = audits.map { |a| @attachment_mapper.map(a) }
    HTTP.post(@project.slack_incoming_webhook_url, json: { attachments: attachments })
    @project.update(slack_updated_at: audits.map(&:created_at).max)
    audits.length
  end
end
