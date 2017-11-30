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

  def try_create_attributes_from_json(json_instance)
    begin
      parsed_json = JSON.parse(json_instance)
    rescue JSON::ParserError
      return
    end

    create_attributes_from_json_hash(parsed_json) if parsed_json.is_a? Hash
  end

  private

  def create_attributes_from_json_hash(hash)
    hash.each do |key, value|
      if value.class <= Array
        next if value.map(&:class).uniq.count != 1
        primitive_class = value.first.class
        create_attribute_from_primitive_class(key, primitive_class, is_array: true)
      else
        create_attribute_from_primitive_class(key, value.class)
      end
      # TODO Clément Villain 30/11/17 handle object and array of object
    end
  end

  def create_attribute_from_primitive_class(key, primitive_class, is_array=false)
    case
    when primitive_class <= Integer
      resource_attributes.create(name: key, primitive_type: :integer, is_array: is_array)
    when primitive_class <= String
      resource_attributes.create(name: key, primitive_type: :string, is_array: is_array)
    when primitive_class <= TrueClass, primitive_class <= FalseClass
      resource_attributes.create(name: key, primitive_type: :boolean, is_array: is_array)
    when primitive_class <= Float
      resource_attributes.create(name: key, primitive_type: :number, is_array: is_array)
    end
  end

  def create_default_resource_representation
    build_default_resource_representation.save
  end

  def build_default_resource_representation
    ResourceRepresentationService.new(self).build_default
  end
end
