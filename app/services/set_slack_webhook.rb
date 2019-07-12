class SetSlackWebhook
  def initialize(project)
    @project = project
  end

  def execute(code, redirect_uri)
    form = {
      client_id: Rails.application.secrets.slack[:client_id],
      client_secret: Rails.application.secrets.slack[:client_secret],
      code: code,
      redirect_uri: redirect_uri
    }
    resp = HTTP.post('https://slack.com/api/oauth.access', form: form)
    incoming_webhook = JSON.parse(resp.body).dig('incoming_webhook')
    return unless incoming_webhook

    @project.update(
      slack_channel: incoming_webhook.dig('channel'),
      slack_incoming_webhook_url: incoming_webhook.dig('url')
    )
  end
end
