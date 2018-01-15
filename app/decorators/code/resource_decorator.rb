class Code::ResourceDecorator < Draper::Decorator
  include Code::DataClass
  delegate_all

  def resource_attributes
    @resource_attributes ||= object.resource_attributes.map do |a|
      Code::AttributeDecorator.new(a)
    end.sort_by(&:variable_name)
  end
end