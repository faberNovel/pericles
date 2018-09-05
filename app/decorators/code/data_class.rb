module Code
  module DataClass
    extend ActiveSupport::Concern

    def rest_name
      "Rest#{pascal_name}"
    end

    def pascal_name
      name.parameterize(separator: '_', preserve_case: true).camelcase
    end

    def kotlin_filename
      "#{rest_name}.kt"
    end

    def java_filename
      "#{rest_name}.java"
    end

    def swift_filename
      "#{rest_name}.swift"
    end

    def ruby_filename
      "#{name.underscore}_serializer.rb"
    end

    def should_import_nullable_annotation
      resource_attributes.any?(&:code_nullable)
    end

    def should_import_java_list
      resource_attributes.any?(&:is_array)
    end
  end
end
