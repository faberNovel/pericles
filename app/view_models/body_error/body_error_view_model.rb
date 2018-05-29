module BodyError
  class BodyErrorViewModel
    attr_reader :path, :description

    def initialize(path, description = nil)
      @path = path
      @description = description
    end

    def readable_path
      path&.gsub(/\/\d+/, '')
    end

    def type
      :unknown
    end

    def valid?
      path.present?
    end
  end
end