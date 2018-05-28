class Attribute < ApplicationRecord
  include HasPrimitiveType

  belongs_to :resource
  belongs_to :scheme

  belongs_to :parent_resource, inverse_of: :resource_attributes, class_name: 'Resource', foreign_key: 'parent_resource_id'

  has_many :attributes_resource_representations, inverse_of: :resource_attribute, dependent: :destroy
  has_many :resource_representations, through: :attributes_resource_representations

  validates :name, presence: true, uniqueness: { scope: [:parent_resource], case_sensitive: true }
  validates :parent_resource, presence: true
  validates :primitive_type, presence: true, if: -> { resource.nil? }
  validates :resource, presence: true, if: -> { primitive_type.nil? }
  validate :type_cannot_be_primitive_type_and_resource
  validates :enum, absence: true, unless: :is_enumerable?
  validates :scheme, absence: true, unless: :string?
  validates :minimum, absence: true, if: :cannot_have_min_max
  validates :maximum, absence: true, if: :cannot_have_min_max
  validates :min_items, absence: true, unless: :is_array
  validates :max_items, absence: true, unless: :is_array

  after_save :update_if_needed_resource_representation_of_attributes_resource_representations

  scope :sorted_by_name, -> { order(:name) }

  audited associated_with: :parent_resource

  def type
    resource_id || primitive_type
  end

  def default_key_name
    name
  end

  private

  def is_enumerable?
    primitive_type && !boolean?
  end

  def type_cannot_be_primitive_type_and_resource
    errors.add(:base, :type_cannot_be_primitive_type_and_resource) unless primitive_type.nil? || resource.nil?
  end

  def cannot_have_min_max
    resource || boolean? || null?
  end

  def update_if_needed_resource_representation_of_attributes_resource_representations
    return unless saved_change_to_resource_id?
    attributes_resource_representations.update(resource_representation: resource&.default_representation)
  end
end
