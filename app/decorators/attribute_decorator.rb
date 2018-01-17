class AttributeDecorator < Draper::Decorator
  delegate_all

  def key_name_placeholder
    name.underscore.parameterize(separator: '_')
  end
end