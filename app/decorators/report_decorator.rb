class ReportDecorator < Draper::Decorator
  delegate_all

  def body_errors
    factory = BodyError::ViewModelFactory.new
    body_error_view_models = object.body_errors.map do |e|
      e.description.split("\n")
    end.flatten.map do |description|
      factory.build(description)
    end

    BodyError::ViewModels.new(*body_error_view_models)
  end

  def tr_class
    return 'in_validation' unless object.validated?
    return 'missing' if object.route.blank? || object.response.blank?
    object.correct? ? '' : 'invalid'
  end
end
