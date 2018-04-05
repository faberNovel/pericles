class ResourceInstanceDecorator < Draper::Decorator
  delegate_all

  def body_errors_by_representations
    object.errors[:instance].each_with_index.reduce({}) do |hash, (errors, i)|
      representation = object.parent.resource_representations[i]
      body_errors = errors.split("\n").map { |e| BodyErrorViewModel.new(e) }
      hash.merge({
        representation => body_errors
      })
    end
  end
end