class Project < ApplicationRecord
  belongs_to :active_mock_profile, class_name: 'MockProfile', foreign_key: 'mock_profile_id'

  has_one :proxy_configuration

  has_many :resources, inverse_of: :project, dependent: :destroy
  has_many :resource_representations, through: :resources
  has_many :routes, through: :resources
  has_many :responses, through: :routes
  has_many :reports
  has_many :mock_profiles
  has_many :api_errors
  has_many :members
  has_many :users, through: :members
  has_many :metadata, inverse_of: :project, dependent: :destroy

  accepts_nested_attributes_for :proxy_configuration, allow_destroy: true

  validates :title, presence: true, length: { in: 2..25 }, uniqueness: true

  after_create :add_default_mock_profile

  scope :of_user, ->(user) { joins(:members).where(members: { user: user }) }

  def build_route_set
    route_set = ActionDispatch::Routing::RouteSet.new
    routes = self.routes
    route_set.draw do
      routes.map do |route|
        match route.url, to: '', via: [route.http_method.downcase.to_sym], controller: 'mocks', action: '', name: route.id
      end
    end
    route_set
  end

  def json_schemas_zip_data
    JSONSchemaZipBuilder.new(self).zip_data
  end

  private

  def add_default_mock_profile
    mock_profiles.create(name: 'DefaultMockProfile')
  end
end
