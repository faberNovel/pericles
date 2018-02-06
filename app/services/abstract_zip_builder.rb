require 'zip'

class AbstractZipBuilder

  def collection
    raise 'implement me!'
  end

  def filename(_object)
    raise 'implement me!'
  end

  def file_content(_object)
    raise 'implement me!'
  end

  def zip_data
    stringio = Zip::OutputStream.write_buffer do |zio|
      collection.each do |object|
        zio.put_next_entry(filename(object))
        zio.write file_content(object)
      end
    end
    stringio.rewind
    stringio.sysread
  end
end
