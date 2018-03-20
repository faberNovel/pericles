class ResourceDecorator < Draper::Decorator
  delegate_all

  def resource_attributes_by_name
    # Note: Clément Villain 29/12/17
    # We do the sorting in ruby and not with active record
    # because we want to keep non persited objects
    object.resource_attributes.sort_by(&:name).map(&:decorate)
  end

  def used_in_resources_links
    object.used_in_resources.map do |r|
      h.link_to(r.name, h.project_resource_path(r.project, r))
    end.to_sentence.html_safe
  end
end