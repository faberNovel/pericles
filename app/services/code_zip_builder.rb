require 'zip'

class CodeZipBuilder
  def initialize(project, language)
    @project = project
    @language = language
  end

  def zip_data
    stringio = Zip::OutputStream.write_buffer do |zio|
      @project.resource_representations.each do |resource_representation|
        zio.put_next_entry(filename(resource_representation))
        zio.write file_content(resource_representation)
      end
    end
    stringio.rewind
    stringio.sysread
  end

  private

  def filename(resource_representation)
    decorated_representation = Code::ResourceRepresentationDecorator.new(resource_representation)
    case @language
    when :kotlin
      decorated_representation.kotlin_filename
    when :java
      decorated_representation.java_filename
    when :swift
      decorated_representation.swift_filename
    end
  end

  def file_content(resource_representation)
    CodeGenerator.new(@language)
      .from_resource_representation(resource_representation)
      .generate
  end
end
