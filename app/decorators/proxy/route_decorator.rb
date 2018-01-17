module Proxy
  class RouteDecorator < Draper::Decorator
    decorates Route

    delegate_all
    decorates_association :responses, with: Proxy::ResponseDecorator
  end
end