class CodeGenerator
  def initialize(language)
    @language = language
  end

  def from_resource(resource)
    @resource = Code::ResourceDecorator.new(resource)
    @project = resource.project
    self
  end

  def from_resource_representation(_resource_representation)
    self
    # TODO Clément Villain 15/01/2018
  end

  def generate
    ApplicationController.render(
      template: "resources/show.#{@language}",
      locals: { resource: @resource, project: @project }
    )
  end
end