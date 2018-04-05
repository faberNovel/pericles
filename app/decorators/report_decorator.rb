class ReportDecorator < Draper::Decorator
  delegate_all

  def body_errors
    body_error_view_models = object.body_errors.map do |e|
      e.description.split("\n")
    end.flatten.map do |description|
      BodyErrorViewModel.new(description)
    end

    BodyErrorsViewModel.new(*body_error_view_models)
  end
end