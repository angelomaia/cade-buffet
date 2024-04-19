Rails.application.routes.draw do
  devise_for :users, path: 'users'
  devise_for :owners, path: 'owners'
  root "home#index"
  get 'home/choice', to: 'home#choice'
  
  resources :buffets, only: [:show, :new, :create, :edit, :update]
  resources :event_types, only: [:show, :new, :create]
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