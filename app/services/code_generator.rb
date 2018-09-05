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
      template: template,
      locals: { resource: @resource, project: @project }
    )
  end

  private

  def template
    if @language.to_sym == :ruby
      "code/serializer.#{@language}"
    else
      "code/rest.#{@language}"
    end
  end
end
