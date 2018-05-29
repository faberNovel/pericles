module BodyError
  class RequiredErrorViewModel < BodyErrorViewModel
    attr_reader :required_properties

    def initialize(path, required_properties)
      super(path)
      @required_properties = required_properties
    end

    def description
      if @required_properties.count == 1
        "#{path} - missing property #{@required_properties.first}"
      else
        "#{path} - missing properties #{@required_properties.join(', ')}"
      end
    end

    def type
      :required
    end

    def merge(vm)
      RequiredErrorViewModel.new(path, required_properties + vm.required_properties)
    end
  end
end