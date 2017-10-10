class Attribute < ApplicationRecord
  enum primitive_type: [:integer, :string, :boolean, :null, :number]

  belongs_to :resource
  belongs_to :scheme

  belongs_to :parent_resource, inverse_of: :resource_attributes, class_name: 'Resource', foreign_key: 'parent_resource_id'
  belongs_to :faker

  has_many :attributes_resource_representations, inverse_of: :resource_attribute, dependent: :destroy
  has_many :resource_representations, through: :attributes_resource_representations

  validates :name, presence: true, uniqueness: { scope: [:parent_resource], case_sensitive: false }
  validates :parent_resource, presence: true
  validates :primitive_type, presence: true, if: "resource.nil?"
  validates :resource, presence: true, if: "primitive_type.nil?"
  validate :type_cannot_be_primitive_type_and_resource
  validates :enum, absence: true, unless: :is_enumerable?
  validates :scheme, absence: true, unless: :string?
  validates :min_length, absence: true, unless: :string?
  validates :max_length, absence: true, unless: :string?
  validates :minimum, absence: true, unless: "self.integer? && enum.blank?"
  validates :maximum, absence: true, unless: "self.integer? && enum.blank?"

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
end
