class Resource < ApplicationRecord
  belongs_to :project, inverse_of: :resources

  has_many :resource_attributes, inverse_of: :parent_resource, class_name: 'Attribute', foreign_key: 'parent_resource_id', dependent: :destroy
  has_many :routes, inverse_of: :resource, dependent: :destroy

  accepts_nested_attributes_for :resource_attributes, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :routes, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: false }
  validates :project, presence: true
end
