class Attribute < ApplicationRecord
  enum primitive_type: [:integer, :string, :boolean, :null, :number]

  belongs_to :resource
  belongs_to :scheme

  belongs_to :parent_resource, inverse_of: :resource_attributes, class_name: 'Resource', foreign_key: 'parent_resource_id'
  belongs_to :faker, class_name: 'AttributeFaker'

  has_many :attributes_resource_representations, inverse_of: :resource_attribute, dependent: :destroy
  has_many :resource_representations, through: :attributes_resource_representations

  validates :name, presence: true, uniqueness: { scope: [:parent_resource], case_sensitive: false }
  validates :parent_resource, presence: true
  validates :primitive_type, presence: true, if: "resource.nil?"
  validates :resource, presence: true, if: "primitive_type.nil?"
  validate :type_cannot_be_primitive_type_and_resource
  validates :enum, absence: true, unless: :is_enumerable?
  validates :scheme, absence: true, unless: :string?
  validates :minimum, absence: true, if: :cannot_have_min_max
  validates :maximum, absence: true, if: :cannot_have_min_max
  validates :min_items, absence: true, unless: :is_array
  validates :max_items, absence: true, unless: :is_array

  after_create :add_attribute_to_default_representation

  scope :sorted_by_name, -> { order(:name) }

  audited associated_with: :parent_resource

  private

  def is_enumerable?
    primitive_type && !self.boolean?
  end

  def type_cannot_be_primitive_type_and_resource
    unless primitive_type.nil? || resource.nil?
      errors.add(:base, :type_cannot_be_primitive_type_and_resource)
    end
  end

  def cannot_have_min_max
    resource || boolean? || null?
  end

  def add_attribute_to_default_representation
    representation = parent_resource.default_representation
    return unless representation

    representation.attributes_resource_representations.create(
      resource_attribute: self,
      is_required: true,
      resource_representation: resource&.default_representation
    )
  end
end
