class Scheme < ApplicationRecord
  validates :name, presence: true

  has_many :resource_attributes, class_name: 'Attribute', dependent: :nullify

  def format?
    regexp.blank?
  end

  def pattern?
    !format?
  end
end
