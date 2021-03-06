require 'zip'

class CodeZipBuilder < AbstractZipBuilder
  def initialize(project, language)
    @project = project
    @language = language
  end

  def collection
    @project.resource_representations
  end

  def filename(resource_representation)
    decorated_representation = Code::ResourceRepresentationDecorator.new(resource_representation)
    case @language
    when :kotlin
      decorated_representation.kotlin_filename
    when :swift
      decorated_representation.swift_filename
    when :ruby
      decorated_representation.ruby_filename
    when :typescript
      decorated_representation.typescript_filename
    end
  end

  def file_content(resource_representation)
    CodeGenerator.new(@language)
      .from_resource_representation(resource_representation)
      .generate
  end
end
