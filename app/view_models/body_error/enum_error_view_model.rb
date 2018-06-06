module BodyError
  class EnumErrorViewModel < BodyErrorViewModel
    attr_reader :current_value, :target_values

    def initialize(path, current_value, target_values)
      super(path)
      @current_value = current_value
      @target_values = target_values
    end

    def description
      "#{path} value is #{current_value} and should be #{target_values}"
    end

    def type
      :enum
    end
  end
end

