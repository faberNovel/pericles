class ResponseDecorator < Draper::Decorator
  delegate_all

  def schema_summary
    h.schema_summary(root_key, resource_representation, is_collection)
  end
end
