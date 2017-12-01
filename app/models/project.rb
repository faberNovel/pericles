class Project < ApplicationRecord
  belongs_to :active_mock_profile, class_name: 'MockProfile', foreign_key: 'mock_profile_id'

  has_many :resources, inverse_of: :project, dependent: :destroy
  has_many :routes, through: :resources
  has_many :responses, through: :routes
  has_many :reports
  has_many :mock_profiles
  has_many :api_errors

  validates :title, presence: true, length: { in: 2..25 }, uniqueness: true

  after_create :add_default_mock_profile

  def build_route_set
    routes = Route.of_project(self)
    route_set = ActionDispatch::Routing::RouteSet.new
    route_set.draw do
      routes.map do |route|
        match route.url, to: '', via: [route.http_method.downcase.to_sym], controller: 'mocks', action: '', name: route.id
      end
    end
    route_set
  end

  private

  def add_default_mock_profile
    mock_profiles.create(name: 'DefaultMockProfile')
  end
end
