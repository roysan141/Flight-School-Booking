Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)

  resources :bookings
  get 'availability', action: :availability, controller: 'pages'
  
  devise_scope :user do
    authenticated :user do
      root :to => 'pages#home'
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new'
    end
    root :to => 'pages#home'
  end
end
