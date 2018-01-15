class Code::AttributeDecorator < Draper::Decorator
  include Code::Field
  delegate_all
  decorates_association :resource, with: Code::ResourceDecorator

  def code_nullable
    @code_nullable ||= object.nullable || parent_resource.resource_representations.any? { |rep| !rep.attributes_resource_representations.any? { |a| a.attribute_id == id  }  }
  end

  def key_name
    object.default_key_name
  end

end