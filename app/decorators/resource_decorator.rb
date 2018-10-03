class ResourceDecorator < Draper::Decorator
  delegate_all

  def used_in_resources_links
    object.used_in_resources.map do |r|
      h.link_to(r.name, h.project_resource_path(r.project, r))
    end.to_sentence.html_safe
  end
end
