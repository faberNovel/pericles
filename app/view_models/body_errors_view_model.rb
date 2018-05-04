class BodyErrorsViewModel
  include Enumerable

  def initialize(*body_error_view_models)
    @body_error_view_models = body_error_view_models.select(&:valid?)
  end

  def grouped_body_error_view_models
    return @grouped_body_error_view_models if defined? @grouped_body_error_view_models
    grouped_by_type = @body_error_view_models.group_by(&:type)
    required_by_path = grouped_by_type[:required]&.group_by(&:path)

    return @body_error_view_models if required_by_path.nil?

    required_view_models = required_by_path.map do |path, view_models|
      next view_models.first if view_models.count == 1
      properties = view_models.map(&:required_property).join(', ')

      BodyErrorViewModel.new(
        "#{path} - missing properties #{properties}"
      )
    end

    @grouped_body_error_view_models = grouped_by_type.except(:required).values.sum([]) + required_view_models
  end

  def each(&block)
    grouped_body_error_view_models.each(&block)
  end
end
