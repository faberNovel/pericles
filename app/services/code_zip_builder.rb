require 'zip'

class CodeZipBuilder
  def initialize(project, language)
    @project = project
    @language = language
  end

  def zip_data
    stringio = Zip::OutputStream.write_buffer do |zio|
      @project.resources.decorate.each do |resource|
        zio.put_next_entry(filename(resource))
        zio.write file_content(resource)
      end
    end
    stringio.rewind
    stringio.sysread
  end

  private

  def filename(resource)
    decorated_resource = Code::ResourceDecorator.new(resource)
    case @language
    when :kotlin
      decorated_resource.kotlin_filename
    when :java
      decorated_resource.java_filename
    when :swift
      decorated_resource.swift_filename
    end
  end

  def file_content(resource)
    CodeGenerator.new(@language).from_resource(resource).generate
  end
end
