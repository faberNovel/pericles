Rails.application.routes.draw do

  resources :projects do
    resources :resources
  end
  resources :resources, only: [] do
    resources :resource_representations, except: [:index]
    resources :routes, except: [:index]
  end
  resources :validations, only: [:create, :new, :index]
  resources :headers, only: [:index]
  root "projects#index"
  match "/not_found", to: "errors#not_found", via: :all
  match '*path', to: "errors#not_found", via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
