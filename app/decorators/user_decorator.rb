class UserDecorator < Draper::Decorator
  include Authorization
  delegate_all
end
