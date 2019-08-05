module Lazy
  extend ActiveSupport::Concern

  module ClassMethods
    def lazy_controller_of(model_name, options = {})
      class_name = (options[:class_name] || model_name).to_s.camelize
      helper_method = options[:helper_method]
      param_key = class_name.underscore.singularize
      if (belongs_to = options[:belongs_to])
        association = class_name.to_s.underscore.pluralize
        new_prefix = "#{belongs_to}.#{association}"
      else
        new_prefix = class_name
      end

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
          model = #{class_name}.find(params[:#{model_name}_id]) if params.has_key? :#{model_name}_id
          model ||= #{class_name}.find(params[:id]) if params.has_key? :id
          model
        end

        def build_#{model_name}_from_params
          return unless params.has_key? :#{param_key}
          model = #{new_prefix}.new(#{model_name}_params) if respond_to?(:#{model_name}_params, true)
          model ||= #{new_prefix}.new(permitted_params) if respond_to?(:permitted_params)
          model ||= #{new_prefix}.new(permitted_attributes(#{class_name})) if respond_to?(:permitted_attributes)
          model
        end

        def new_#{model_name}
          #{new_prefix}.new
        end
        #{helper_method ? "helper_method(:#{model_name})" : ''}

      METHODS
    end

    def decorates_method(model_name)
      _helper_methods << model_name

      _helpers.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
        def #{model_name}
          return @_#{model_name} if defined? @_#{model_name}
          @_#{model_name} = controller.send(:#{model_name}).decorate
        end
      ruby_eval
    end
  end
end
