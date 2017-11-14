Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :projects do
    resources :resources
    resources :routes, only: [:index]
    resources :reports, only: [:index, :show]
    resources :mock_profiles, only: [:index, :new, :create]
    match 'mocks', to: "mocks#compute_mock", via: :all, as: 'mocks_root'
    match 'mocks/*path', to: "mocks#compute_mock", via: :all, as: 'mocks'
    match 'proxy', to: "proxy#compute_request", via: :all, format: false
    match 'proxy/*path', to: "proxy#compute_request", via: :all, format: false
    resources :mock_profiles do
      match 'mocks', to: "mock_profiles#compute_mock", via: :all, as: 'mocks_root'
      match 'mocks/*path', to: "mock_profiles#compute_mock", via: :all, as: 'mocks'
    end
  end
  resources :resources, only: [] do
    resources :resource_representations, except: [:index]
    resources :routes, except: [:index]
    resources :mock_instances, only: [:new, :create]
  end
  resources :routes, only: [] do
    resources :responses, except: [:index, :show]
  end
  resources :mock_instances, only: [:edit, :update, :destroy]
  resources :mock_profiles, only: [:edit, :update]
  resources :validations, only: [:create, :new, :index]
  resources :instances, only: [:create]
  resources :headers, only: [:index]
  resources :users, only: [:show]
  resources :schemes, only: [:create, :new, :index, :destroy]
  root "projects#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
