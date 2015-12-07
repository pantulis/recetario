# -*- coding: utf-8 -*-

RecetarioRails4::Application.routes.draw do
  root to: 'dashboard#index'

  resources :ingredients
  resources :recipes
  resources :plans do
    member do
      get 'toodledo'
      get 'wunderlist'
    end
  end
end
