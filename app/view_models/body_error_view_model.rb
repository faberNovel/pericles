class BodyErrorViewModel
  def initialize(description)
    @original_description = description
  end

  def readable_path
    path&.gsub(/\/\d+/, '')
  end

  def description
    case type
    when :additional
      "#{path} - additional properties #{additional_list}"
    when :required
      "#{path} - missing property #{required_property}"
    when :type
      if current_type == 'null'
        "#{path} - cannot be null"
      else
        "#{path} - wrong type: #{current_type} instead of #{target_type}"
      end
    else
      @original_description
    end
  end

  def type
    if shorten_description.include? 'contains additional properties'
      :additional
    elsif shorten_description.include? 'did not contain a required property of'
      :required
    elsif shorten_description.include? 'did not match the following type:'
      :type
    end
  end

  def path
    match = /The property '(#\/[^']*)'/.match(shorten_description)
    return unless match

    if match[1] == '#/'
      'root'
    else
      match[1].gsub(/^#\//, '')
    end
  end

  def required_property
    /did not contain a required property of ('[^']+')/.match(shorten_description)[1]
  end

  def valid?
    path.present?
  end

  private

  def current_type
    /of type (.*) did not match the following type: (.*)/.match(shorten_description)[1]
  end

  def target_type
    /of type (.*) did not match the following type: (.*)/.match(shorten_description)[2]
  end

  def additional_list
    /\[([^\]]+)\]/.match(shorten_description)[1]
  end

  def shorten_description
    @original_description
      .gsub(/ outside of the schema when none are allowed in schema(.*)/, '')
      .gsub(/ in schema(.*)/, '')
  end
end
