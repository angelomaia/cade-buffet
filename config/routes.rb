Rails.application.routes.draw do
  root "home#index"
  get 'home/choice', to: 'home#choice'

  devise_for :users, path: 'users', controllers: {
    registrations: 'users/registrations'
  }
  devise_for :owners, path: 'owners', controllers: {
    sessions: 'owners/sessions',
  }
  
  resources :orders, only: [:new, :create, :show, :index] do
    get 'owner', on: :collection
    get 'details', on: :member
    get 'evaluation', on: :member
    post 'create_order_price', on: :member
    post 'confirm', on: :member
    post 'new_user_message', on: :member
    post 'new_buffet_message', on: :member
  end

  resources :buffets, only: [:show, :new, :create, :edit, :update] do
    get 'buffet_search', on: :collection
  end
  
  resources :event_types, only: [:show, :edit, :update, :new, :create]
end