class ResourceDecorator < Draper::Decorator
  delegate_all

  def resource_attributes_by_name
    # Note: Clément Villain 29/12/17
    # We do the sorting in ruby and not with active record
    # because we want to keep non persited objects
    object.resource_attributes.decorate.sort_by(&:name)
  end

  def used_in_resources_links
    object.used_in_resources.map do |r|
      h.link_to(r.name, h.project_resource_path(r.project, r))
    end.to_sentence.html_safe
  end

  def find_dependencies(value = object.name, dependency_tree = find_flatten_dependencies)
    res = {}
    if dependency_tree.key? value
      dependency_tree.dig(value).each do |dependent_value|
        dependencies = find_dependencies(dependent_value, dependency_tree.except(value))
        res[dependent_value] = dependencies
      end
    end
    res
  end

  def find_flatten_dependencies(accumulator = {})
    attributes_with_resource_type = object.resource_attributes.is_resource.joins(:resource)
    return accumulator unless attributes_with_resource_type.size.positive?

    accumulator[object.name] = attributes_with_resource_type.pluck('resources.name').uniq
    attributes_with_resource_type.each do |attribute|
      next if accumulator.key? attribute.resource.name
      attribute_dependency_tree = attribute.resource.decorate.find_flatten_dependencies(accumulator)
      accumulator.merge attribute_dependency_tree
    end
    accumulator
  end

end
