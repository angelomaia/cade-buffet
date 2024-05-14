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
    post 'user_cancel', on: :member
    post 'owner_cancel', on: :member
    post 'new_user_message', on: :member
    post 'new_buffet_message', on: :member
  end

  resources :buffets, only: [:show, :new, :create, :edit, :update] do
    get 'buffet_search', on: :collection
  end
  
  resources :event_types, only: [:show, :edit, :update, :new, :create] do
    delete 'delete_photo/:photo_id', to: 'event_types#delete_photo', as: 'delete_photo'
  end

  namespace :api do
    namespace :v1 do
      resources :buffets, only: [:index, :show] do
        resources :event_types, only: [:index]
      end
      get 'availability_check', to: 'event_types#availability_check'
    end
  end
end