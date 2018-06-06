module BodyError
  class TypeErrorViewModel < BodyErrorViewModel
    attr_reader :current_type, :target_types

    def initialize(path, current_type, target_types)
      super(path)
      @current_type = current_type
      @target_types = target_types
    end

    def type
      :type
    end

    def description
      if @current_type == 'null'
        "#{path} - cannot be null"
      else
        "#{path} - wrong type: #{@current_type} instead of #{@target_types.join(' or ')}"
      end
    end

    def merge(vm)
      TypeErrorViewModel.new(path, current_type, target_types + vm.target_types)
    end
  end
end
