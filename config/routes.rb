Rails.application.routes.draw do

  resources :projects do
    resources :json_schemas
    resources :resources
  end
  root "projects#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
