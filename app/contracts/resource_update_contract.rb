class ResourceUpdateContract
  def initialize(resource, resource_params)
    @resource = resource
    @resource_params = resource_params
  end

  def update
    release_attribute_name_unique_constraint do
      @resource.update(@resource_params)
    end
  rescue ActiveRecord::RecordNotUnique => e
    add_error_to_invalid_attribute(e)
    false
  end

  private

  def add_error_to_invalid_attribute(e)
    taken_attribute_name = /=\(\d+, (.*)\) already exists./.match(e.to_s)[1]
    taken_attribute = @resource.resource_attributes.reject(&:id).find { |a| a.name == taken_attribute_name }
    taken_attribute.errors.add(:name, :taken)
  end

  def release_attribute_name_unique_constraint(&block)
    @resource.transaction do
      add_collision_placeholder && block.call && remove_collision_placeholder
    end
  end

  def remove_collision_placeholder
    attributes_whose_name_changes.all? do |a|
      a.update(name: a.name.gsub(/^AVOID_COLLISION/, ''))
    end
  end

  def add_collision_placeholder
    attributes_whose_name_changes.all? do |a|
      a.update(name: "AVOID_COLLISION#{a.name}")
    end
  end

  def attributes_whose_name_changes
    @resource.resource_attributes.select do |a|
      attribute_param = @resource_params[:resource_attributes_attributes]&.values&.find { |hash| a.id == hash[:id].to_i }
      attribute_param && (a.name != attribute_param[:name])
    end
  end
end
