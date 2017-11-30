class Resource < ApplicationRecord
  after_create :create_default_resource_representation

  belongs_to :project, inverse_of: :resources

  has_many :resource_attributes, inverse_of: :parent_resource, class_name: 'Attribute', foreign_key: 'parent_resource_id', dependent: :destroy
  has_many :routes, inverse_of: :resource, dependent: :destroy
  has_many :resource_representations, inverse_of: :resource, dependent: :destroy
  has_many :reports, through: :routes
  has_many :resource_instances

  accepts_nested_attributes_for :resource_attributes, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :routes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: false }
  validates :project, presence: true

  audited
  has_associated_audits

  def json_schema
    ResourceRepresentationSchemaSerializer.new(
      build_default_resource_representation,
      is_collection: false,
      root_key: ''
    ).as_json
  end

  def has_invalid_mocks?
    resource_instances.any? { |mock| !mock.valid? }
  end

  def default_representation
    resource_representations.order(:created_at).first
  end

  private

  def create_default_resource_representation
    build_default_resource_representation.save
  end

  def build_default_resource_representation
    ResourceRepresentationService.new(self).build_default
  end
end
