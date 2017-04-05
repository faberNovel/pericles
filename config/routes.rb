Rails.application.routes.draw do

  resources :projects do
    resources :resources do
      resources :routes, except: [:index]
      resources :attributes, only: [:destroy]
    end
  end
  resources :validations, only: [:create, :new, :index]
  root "projects#index"
  match "/not_found", to: "errors#not_found", via: :all
  match '*path', to: "errors#not_found", via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
