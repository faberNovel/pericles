class ReportDecorator < Draper::Decorator
  delegate_all

  def body_errors
    object.body_errors.map do |e|
      e.description.split("\n")
    end.flatten.map do |description|
      BodyErrorViewModel.new(description)
    end
  end
end