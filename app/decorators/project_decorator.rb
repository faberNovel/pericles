class ProjectDecorator < Draper::Decorator
  delegate_all

  def member_list
    "#{I18n.t('projects.show.internal_members')}#{(' and ' + users.pluck(:email).join(', ')) if users.any?}"
  end
end
