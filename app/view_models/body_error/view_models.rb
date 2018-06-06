module BodyError
  class ViewModels
    include Enumerable

    def initialize(*body_error_view_models)
      @body_error_view_models = body_error_view_models.select(&:valid?)
    end

    def grouped_body_error_view_models
      return @grouped_body_error_view_models if defined? @grouped_body_error_view_models

      grouped_by_type = @body_error_view_models.group_by(&:type)
      grouped_by_type[:required] = merge(grouped_by_type[:required])
      grouped_by_type[:type] = merge(grouped_by_type[:type])

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

    def merge(view_models)
      return [] unless view_models
      view_models.group_by(&:path).map do |path, vms|
        vms.reduce(&:merge)
      end
    end
  end
end