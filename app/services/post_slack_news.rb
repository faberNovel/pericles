class PostSlackNews
  def initialize(project)
    @project = project
  end

  def execute(since = 1.day.ago)
    audits = Audited::Audit
      .of_project(@project)
      .where('created_at > ?', since)
      .where.not(auditable_type: ['Header', 'QueryParameter'])
      .preload(:auditable, :associated)
      .order(created_at: :desc)
      .map(&:decorate)

    blocks = audits.map do |audit|
      {
        type: :section,
        text: {
          type: :mrkdwn,
          text: audit.to_s # TODO Get markdown instead of HTML
        }
      }
    end

    HTTP.post(@project.slack_incoming_webhook_url, json: { blocks: blocks })
  end
end
