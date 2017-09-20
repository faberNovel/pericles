class Resource < ApplicationRecord
  after_create :create_default_resource_representation

  belongs_to :project, inverse_of: :resources

  has_many :resource_attributes, inverse_of: :parent_resource, class_name: 'Attribute', foreign_key: 'parent_resource_id', dependent: :destroy
  has_many :routes, inverse_of: :resource, dependent: :destroy
  has_many :resource_representations, inverse_of: :resource, dependent: :destroy

  accepts_nested_attributes_for :resource_attributes, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :routes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: false }
  validates :project, presence: true

  private

  def create_default_resource_representation
    resource_representation = self.resource_representations.create(name: "default_representation",
      description: "Automatically generated")
    self.resource_attributes.each do |attribute|
      resource_referenced_by_attribute_representation = attribute.resource&.resource_representations&.first
      resource_representation.attributes_resource_representations.create(
        resource_attribute: attribute,
        is_required: true,
        resource_representation: resource_referenced_by_attribute_representation
      )
    end
  end
end
