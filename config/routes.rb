Rails.application.routes.draw do

  resources :projects do
    resources :json_schemas
    resources :resources do
      resources :routes, except: [:index]
      resources :attributes, only: [:destroy]
    end
  end
  root "projects#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
