Rails.application.routes.draw do
  # get 'expenses/index'
  # get 'expenses/new'
  # post 'expenses/create'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :expenses do
    patch 'settle_up', on: :collection
  end
  # get 'add_item', to: 'expenses#add_item'
  root to: "static#dashboard"
  get 'people/:id', to: 'static#person'
end
