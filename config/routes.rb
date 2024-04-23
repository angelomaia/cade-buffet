Rails.application.routes.draw do
  devise_for :users, path: 'users'
  devise_for :owners, path: 'owners'
  root "home#index"
  get 'home/choice', to: 'home#choice'
  
  resources :buffets, only: [:show, :new, :create, :edit, :update] do
    get 'buffet_search', on: :collection
  end
  resources :event_types, only: [:show, :edit, :update, :new, :create] do
    get 'event_type_prices', on: :member
  end
end

# Devise alert:

# Some setup you must do manually if you haven't yet:

#   Ensure you have overridden routes for generated controllers in your routes.rb.
#   For example:

#     Rails.application.routes.draw do
#       devise_for :users, controllers: {
#         sessions: 'users/sessions'
#       }
#     end