module BodyError
  class AdditionalErrorViewModel < BodyErrorViewModel
    attr_reader :additional_list

    def initialize(path, additional_list)
      super(path)
      @additional_list = additional_list
    end

    def description
      "#{path} - additional properties #{@additional_list}"
    end

    def type
      :additional
    end
  end
end