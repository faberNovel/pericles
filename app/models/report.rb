class Report < ApplicationRecord
  belongs_to :project
  belongs_to :route, optional: true
  belongs_to :response, optional: true

  has_many :validation_errors, dependent: :delete_all

  default_scope { includes(:validation_errors) }

  validates :response_status_code, :response_headers, :request_headers, presence: true

  def correct?
    validation_errors.empty?
  end

  def errors?
    !correct?
  end

  def valid_status?
    status_error.blank?
  end

  def status_error
    validation_errors.find(&:status_code?)
  end

  def header_errors
    validation_errors.select(&:header?)
  end

  def body_errors
    validation_errors.select(&:body?)
  end
end
