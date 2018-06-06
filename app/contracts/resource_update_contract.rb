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

    new_attributes = @resource.resource_attributes.reject(&:id)
    potential_invalid_attributes = new_attributes + attributes_with_dirty_names

    taken_attribute = potential_invalid_attributes.find { |a| a.name == taken_attribute_name }
    taken_attribute.errors.add(:name, :taken)
  end

  def release_attribute_name_unique_constraint(&block)
    @resource.transaction do
      add_collision_placeholder && block.call && remove_collision_placeholder
    end
  end

  def remove_collision_placeholder
    attributes_with_dirty_names.all? do |a|
      a.destroyed? || a.update(name: a.name.gsub(/^AVOID_COLLISION/, ''))
    end
  end

  def add_collision_placeholder
    attributes_with_dirty_names.all? do |a|
      a.update(name: "AVOID_COLLISION#{a.name}")
    end
  end

  def attributes_with_dirty_names
    @attributes_whose_name_changes ||= begin
      attribute_hashes = @resource_params[:resource_attributes_attributes]&.values
      @resource.resource_attributes.select do |a|
        attribute_param = attribute_hashes&.find { |hash| a.id == hash[:id].to_i }
        attribute_param && (a.name != attribute_param[:name])
      end
    end
  end
end
