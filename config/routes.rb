RecetarioRails4::Application.routes.draw do

  root to: 'dashboard#index'

  resources :ingredients
  resources :recipes
  resources :plans do 
    member do 
      get 'export'
    end
  end
  

end
