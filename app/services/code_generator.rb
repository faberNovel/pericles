class CodeGenerator
  def initialize(language)
    @language = language
  end

  def from_resource(resource)
    @resource = Code::ResourceDecorator.new(resource)
    @project = resource.project
    self
  end

  def from_resource_representation(resource_representation)
    @resource = Code::ResourceRepresentationDecorator.new(resource_representation)
    @project = @resource.resource.project
    self
  end

  def generate
    ApplicationController.render(
      template: "code/rest.#{@language}",
      locals: { resource: @resource, project: @project }
    )
  end
end