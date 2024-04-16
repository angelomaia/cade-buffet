Rails.application.routes.draw do
  devise_for :users
  devise_for :owners
  root "home#index"
  get 'home/choice', to: 'home#choice'
  
  resources :buffets, only: [:show, :new, :create, :edit, :update]
end
