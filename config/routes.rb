Rails.application.routes.draw do
  devise_for :users
  root :to => 'schedules#index', :constraints => lambda { |request| request.env['warden'].user.is_trainer?}
root :to => 'bookings#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
