class AttributeDecorator < Draper::Decorator
  delegate_all

  def key_name_placeholder
    name.underscore.parameterize(separator: '_')
  end

  def readable_type
    base_type = resource&.name || primitive_type.to_s.capitalize
    is_array ? "Array<#{base_type}>" : base_type
  end
end