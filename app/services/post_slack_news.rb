class PostSlackNews
  def initialize(project, http_host = ENV['MAIL_DEFAULT_URL'])
    @project = project
    @renderer = AuditsController.renderer.new(http_host: http_host)
  end

  def execute(since = 1.day.ago)
    audits = Audited::Audit
      .of_project(@project)
      .where('created_at > ?', since)
      .where.not(auditable_type: ['Header', 'QueryParameter'])
      .preload(:auditable, :associated)
      .order(created_at: :desc)
      .map(&:decorate)

    attachments = audits.map do |audit|
      {
        color: color(audit),
        blocks: [
          type: :section,
          text: {
            type: :mrkdwn,
            text: text(audit) # TODO Get markdown instead of HTML
          }
        ]
      }
    end

    return if attachments.empty?
    HTTP.post(@project.slack_incoming_webhook_url, json: { attachments: attachments })
  end

  private

  def color(audit)
    case audit.action_css_class
    when 'create'
      '#00b593'
    when 'update'
      '#ffac14'
    when 'destroy'
      '#c11325'
    end
  end

  def text(audit)
    if audit.partial_name
      @renderer.render(
        partial: audit.partial_name,
        locals: { audit: audit },
        formats: :mrkdwn
      )
    else
      audit.to_s
    end
  end
end
