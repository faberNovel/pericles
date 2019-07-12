class PostSlackNews
  class SlackAttachmentMapper
    def initialize(http_host = ENV['MAIL_DEFAULT_URL'])
      @renderer = AuditsController.renderer.new(http_host: http_host)
    end

    def map(audit)
      {
        color: color(audit),
        blocks: [
          type: :section,
          text: {
            type: :mrkdwn,
            text: text(audit)
          }
        ]
      }
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
      @renderer.render(
        partial: audit.partial_name,
        locals: { audit: audit },
        formats: :mrkdwn
      )
    end
  end
end
