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
    case @language
    when :kotlin
      resource.kotlin_filename
    when :java
      resource.java_filename
    when :swift
      resource.swift_filename
    end
  end

  def file_content(resource)
    ApplicationController.render(
      template: "resources/show.#{@language}",
      locals: { resource: resource, project: @project }
    )
  end
end
