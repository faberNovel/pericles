class ResourceRepresentation < ApplicationRecord
  belongs_to :resource, inverse_of: :resource_representations

  has_many :attributes_resource_representations, inverse_of: :parent_resource_representation,
                                                 foreign_key: 'parent_resource_representation_id', dependent: :destroy
  has_many :resource_attributes, through: :attributes_resource_representations
  has_many :responses, inverse_of: :resource_representation
  has_many :request_routes, inverse_of: :request_resource_representation, foreign_key: 'request_resource_representation_id', class_name: 'Route'

  delegate :project, to: :resource

  accepts_nested_attributes_for :attributes_resource_representations, allow_destroy: true

  validates :name, presence: true, uniqueness: { scope: [:resource], case_sensitive: false }
  validates :resource, presence: true

  audited
  has_associated_audits

  def json_schema
    JSONSchema::ResourceRepresentationDecorator.new(self).json_schema
  end

  def resource_instances
    ResourceInstance.where(resource: resource).select { |r| r.body_valid?(json_schema)  }
  end

  def attributes_resource_representation(attribute)
    attributes_resource_representations.find_by(resource_attribute: attribute)
  end

  def find_parent_resource_representations
    parent_resource_representations = []
    referencing_associations = AttributesResourceRepresentation.where(resource_representation_id: id)
    referencing_associations.each { |association| parent_resource_representations << association.parent_resource_representation }
    parent_resource_representations.uniq.each do |resource_representation|
      parent_resource_representations.concat(resource_representation.find_parent_resource_representations)
    end
    parent_resource_representations.uniq
  end
end
