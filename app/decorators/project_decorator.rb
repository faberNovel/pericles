class ProjectDecorator < Draper::Decorator
  delegate_all

  def member_list
    "#{I18n.t('projects.show.internal_members')}#{(' and ' + users.pluck(:email).join(', ')) if users.any?}"
  end

  def proxy_url
    proxy_options = ENV['PROXY_HOST'] ? { host: ENV['PROXY_HOST'] } : {}
    h.project_proxy_url(self, proxy_options)
  end
end
