module ApplicationHelper
  def active_class(controller_class)
    controller_class == controller.class ? 'active' : ''
  end
end
