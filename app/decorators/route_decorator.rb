class RouteDecorator < Draper::Decorator
  delegate_all

  def responses
    object.responses.order(:status_code)
  end

  def resource_representations_links
    object.resource_representations.uniq.map do |r|
      h.link_to(r.name, h.project_resource_path(r.project, r.resource_id, anchor: "res-#{r.id}"))
    end.to_sentence.html_safe
  end
end