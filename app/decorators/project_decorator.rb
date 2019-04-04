class ProjectDecorator < Draper::Decorator
  delegate_all

  def member_list
    "#{I18n.t('projects.show.internal_members')}#{(' and ' + users.pluck(:email).join(', ')) if users.any?}"
  end

  def proxy_url
    return 'Please defined PROXY_HOST env variable' unless ENV['PROXY_HOST']
    h.project_url(self, { host: ENV['PROXY_HOST'] }) + '/proxy'
  end
end
