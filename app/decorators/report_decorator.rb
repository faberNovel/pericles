class ReportDecorator < Draper::Decorator
  delegate_all

  def body_errors
    object.body_errors.map { |e| e.description.split("\n") }.flatten
  end
end