module Lazy
  extend ActiveSupport::Concern

  module ClassMethods
    def lazy_controller_of(model_name, options = {})
      class_name = options[:class_name].nil? ? model_name.to_s.camelize : options[:class_name].to_s
      helper_method = options[:helper_method]

      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def #{model_name}
          return @#{model_name} if defined? @#{model_name}
          @#{model_name} = begin
            #{model_name} = find_#{model_name}
            #{model_name} ||= build_#{model_name}_from_params
            #{model_name} ||= new_#{model_name}
            authorize #{model_name} if respond_to?(:authorize)
            #{model_name}
          end
        end

        def find_#{model_name}
          model = #{class_name}.find(params[:id]) if params.has_key? :id
          model ||= #{class_name}.find(params[:#{model_name}_id]) if params.has_key? :#{model_name}_id
          model
        end

        def build_#{model_name}_from_params
          return unless params.has_key? :#{model_name}
          model = #{class_name}.new(permitted_attributes(#{class_name})) if respond_to?(:permitted_attributes)
          model ||= #{class_name}.new(permitted_params) if respond_to?(:permitted_params)
          model
        end

        def new_#{model_name}
          #{class_name}.new
        end
        #{helper_method ? "helper_method(:#{model_name})" : ''}

      METHODS
    end

    def decorates_method(model_name)
      self._helper_methods << model_name

      _helpers.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
        def #{model_name}
          return @_#{model_name} if defined? @_#{model_name}
          @_#{model_name} = controller.send(:#{model_name}).decorate
        end
      ruby_eval
    end

  end
end