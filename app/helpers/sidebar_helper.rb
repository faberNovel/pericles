module SidebarHelper
  def active_class(controller_class)
    controller_class == controller.class ? 'active' : ''
  end

  def push_class(pusher)
    should_add_push_class = (
      (pusher == 'Schemes' && (controller.class == ProjectsController || controller.class.included_modules.include?(ProjectRelated))) ||
      (pusher == 'JSON Validation' && (controller.class == SchemesController)) ||
      (pusher == 'Logout' && (controller.class == ValidationsController))
    )
    should_add_push_class ? 'push' : ''
  end
end
