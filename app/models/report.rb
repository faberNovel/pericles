class Report < ApplicationRecord
  belongs_to :route

  has_many :validation_errors

  validates :status_code, :body, :headers, presence: true

  def correct?
    self.validation_errors.empty?
  end

  def errors?
    !correct?
  end
end
