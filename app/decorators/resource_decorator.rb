class ResourceDecorator < Draper::Decorator
  delegate_all

  def rest_name
    "Rest#{name.camelcase}"
  end
end