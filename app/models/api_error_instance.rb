class ApiErrorInstance < ApplicationRecord
  include Instance

  belongs_to :api_error
  delegate :project, to: :api_error

  def parent
    api_error
  end
end
