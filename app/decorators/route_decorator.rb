class RouteDecorator < Draper::Decorator
  delegate_all

  def responses
    object.responses.order(:status_code)
  end

  def representations_grouped_options
    resources = project.resources.preload(:resource_representations).to_a
    resources = resources.sort_by { |r| r.name.downcase }
    promote_route_resource(resources)

    resources.map do |r|
      [
        r.name,
        r.resource_representations.sort_by do |rep|
          rep.name.downcase
        end.map { |rep| [rep.name, rep.id] }
      ]
    end
  end

  def resource_representations_links
    object.resource_representations.uniq.map do |r|
      h.link_to(
        r.name,
        h.project_resource_path(r.project, r.resource_id, anchor: "res-#{r.id}")
      )
    end.to_sentence.html_safe
  end

  private

  def promote_route_resource(resources)
    first_resource_index = resources.find_index { |r| r.id == resource_id }
    resources.insert(0, resources.delete_at(first_resource_index))
  end
end