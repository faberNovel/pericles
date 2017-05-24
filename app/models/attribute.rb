class Attribute < ApplicationRecord
  enum primitive_type: [:integer, :number, :string, :boolean, :null]

  belongs_to :resource
  belongs_to :parent_resource, inverse_of: :resource_attributes, class_name: 'Resource', foreign_key: 'parent_resource_id'

  validates :name, presence: true, uniqueness: { scope: [:parent_resource], case_sensitive: false }
  validates :parent_resource, presence: true
  validates :primitive_type, presence: true, if: "resource.nil?"
  validates :resource, presence: true, if: "primitive_type.nil?"
  validate :type_cannot_be_primitive_type_and_resource
  validates :enum, absence: true, unless: "primitive_type"

  private

  def type_cannot_be_primitive_type_and_resource
    unless primitive_type.nil? || resource.nil?
      errors.add(:base, :type_cannot_be_primitive_type_and_resource)
    end
  end
end
