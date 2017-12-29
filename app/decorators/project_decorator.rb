class ProjectDecorator < Draper::Decorator
  delegate_all

  def member_list
    "All FABERNOVEL#{(' and ' + users.pluck(:email).join(', ')) if users.any?}"
  end
end
