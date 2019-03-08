class Resource < ApplicationRecord
  after_create :create_default_resource_representation

  belongs_to :project, inverse_of: :resources

  has_many :resource_attributes, inverse_of: :parent_resource, class_name: 'Attribute', foreign_key: 'parent_resource_id', dependent: :destroy
  has_many :routes, inverse_of: :resource, dependent: :destroy
  has_many :responses, through: :routes
  has_many :resource_representations, inverse_of: :resource, dependent: :destroy
  has_many :reports, through: :routes
  has_many :resource_instances
  has_many :referencing_attributes, class_name: 'Attribute'
  has_many :used_in_resources, through: :referencing_attributes, source: :parent_resource
  has_many :used_resources, -> { distinct }, through: :resource_attributes, source: :resource
  has_many :request_routes, -> { distinct }, through: :resource_representations, source: :request_routes, class_name: 'Route'

  accepts_nested_attributes_for :resource_attributes, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :routes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: false }
  validates :project, presence: true

  scope :not_used_in_other_resources, -> {
    left_outer_joins(:referencing_attributes).where('attributes.resource_id IS NULL OR attributes.resource_id = attributes.parent_resource_id')
  }

  audited
  has_associated_audits

  def json_schema
    schemas = resource_representations.map(&:json_schema)
    definitions = schemas.map { |s| s.delete :definitions }.reduce({}, :merge)
    {
      "definitions": definitions,
      "anyOf": schemas
    }
  end

  def has_invalid_mocks?
    resource_instances.any? { |mock| !mock.valid? }
  end

  def default_representation
    resource_representations.order(:created_at).first
  end

  def try_create_attributes_from_json(json_instance)
    AttributesImporter.new(self).import_from_json_instance(json_instance)
    resource_attributes.each do |attribute|
      default_representation.attributes_resource_representations.create(
        resource_attribute: attribute,
        is_required: true,
        resource_representation: attribute.resource&.default_representation
      )
    end
  end

  private

  def create_default_resource_representation
    build_default_resource_representation.save
  end

  def build_default_resource_representation
    ResourceRepresentationService.new(self).build_default
  end
end
