class BodyErrorsViewModel
  include Enumerable

  def initialize(*body_error_view_models)
    @body_error_view_models = body_error_view_models.select(&:valid?)
  end

  def grouped_body_error_view_models
    return @grouped_body_error_view_models if defined? @grouped_body_error_view_models

    grouped_by_type = @body_error_view_models.group_by(&:type)

    required_errors = grouped_by_type[:required]
    grouped_by_type[:required] = merge_required(required_errors) if required_errors

    type_errors = grouped_by_type[:type]
    grouped_by_type[:type] = merge_type(type_errors) if type_errors

    @grouped_body_error_view_models = grouped_by_type.values.sum([])
  end

  def each(&block)
    grouped_body_error_view_models.each(&block)
  end

  private

  def merge_required(required_view_models)
    merge_same_path(required_view_models) do |view_models|
      properties = view_models.map(&:required_property).join(', ')
      "missing properties #{properties}"
    end
  end

  def merge_type(type_view_models)
    merge_same_path(type_view_models) do |view_models|
      current_type = view_models.first.current_type
      types = view_models.map(&:target_type).join(' or ')
      "wrong type: #{current_type} instead of #{types}"
    end
  end

  def merge_same_path(body_error_view_models)
    body_error_view_models.group_by(&:path).map do |path, view_models|
      next view_models.first if view_models.count == 1
      BodyErrorViewModel.new("#{path} - #{yield(view_models)}")
    end
  end
end
