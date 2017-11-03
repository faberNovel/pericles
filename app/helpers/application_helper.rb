module ApplicationHelper
  def active_class(controller_class)
    controller_class == controller.class ? 'active' : ''
  end

  def top_nav_active_class(path)
    return request.url.include?(path) ? 'active' : ''
  end
end
