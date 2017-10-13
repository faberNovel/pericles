class Project < ApplicationRecord
  has_many :resources, inverse_of: :project, dependent: :destroy
  has_many :routes, through: :resources
  has_many :reports

  validates :title, presence: true, length: { in: 2..25 }, uniqueness: true
  validates :description, length: { maximum: 500 }


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

end
