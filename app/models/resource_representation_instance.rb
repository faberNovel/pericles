class ResourceRepresentationInstance
  attr_accessor :resource_instance, :response

  def initialize(resource_instance, response)
    self.resource_instance = resource_instance
    self.response = response
  end

  def name
    resource_instance.name
  end

  def body
    resource_instance.body_sliced_with(response.resource_representation)
  end
end