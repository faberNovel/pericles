Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :projects do
    resources :resources
    resources :routes, only: [:index]
    match 'mocks/*path', to: "mocks#compute_mock", via: :all
    match 'proxy/*path', to: "proxy#compute_request", via: :all, format: false
  end
  resources :resources, only: [] do
    resources :resource_representations, except: [:index]
    resources :routes, except: [:index]
  end
  resources :routes, only: [] do
    resources :responses, except: [:index, :show]
  end
  resources :validations, only: [:create, :new, :index]
  resources :instances, only: [:create]
  resources :headers, only: [:index]
  resources :users, only: [:show]
  resources :schemes, only: [:create, :new, :index, :destroy]
  root "projects#index"
  match "/not_found", to: "errors#not_found", via: :all
  match '*path', to: "errors#not_found", via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
