class RouteDecorator < Draper::Decorator
  delegate_all

  def responses
    object.responses.order(:status_code)
  end
end