class Report < ApplicationRecord
  belongs_to :route

  has_many :validation_errors

  default_scope { includes(:validation_errors) }

  validates :response_status_code, :response_headers, :request_headers, presence: true

  def correct?
    self.validation_errors.empty?
  end

  def errors?
    !correct?
  end

  def valid_status?
    self.validation_errors.find { |e| e.status_code? }.blank?
  end

  def header_errors
    self.validation_errors.select { |e| e.header? }
  end

  def body_errors
    self.validation_errors.select { |e| e.body? }
  end
end
