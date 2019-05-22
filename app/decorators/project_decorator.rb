class ProjectDecorator < Draper::Decorator
  delegate_all

  def member_list
    "#{I18n.t('projects.show.internal_members')}#{(' and ' + users.pluck(:email).join(', ')) if users.any?}"
  end

  def proxy_url
    return 'Please defined PROXY_HOST env variable' unless ENV['PROXY_HOST']
    h.project_url(self, { host: ENV['PROXY_HOST'] }) + '/proxy'
  end

  def resource_representation_name_as_swagger_uid
    duplicated_names = resource_representations
      .group_by(&:name)
      .select { |_, resource_representations| resource_representations.length > 1 }
      .map { |n, r| "#{n} (#{r.map(&:resource).map(&:name).join(', ')})" }
      .join(', ')
    return if duplicated_names.empty?

    I18n.t('projects.show.resource_representation_name_as_swagger_uid', duplicated_names: duplicated_names)
  end
end
