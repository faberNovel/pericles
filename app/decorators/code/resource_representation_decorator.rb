class Code::ResourceRepresentationDecorator < Draper::Decorator
  include Code::DataClass
  delegate_all

  def resource_attributes
    @resource_attributes ||= object.attributes_resource_representations.map do |a|
      Code::AttributesResourceRepresentationDecorator.new(a)
    end.sort_by(&:variable_name)
  end
end