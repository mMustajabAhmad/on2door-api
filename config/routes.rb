Rails.application.routes.draw do
  get '/icon.png', to: proc { [204, {}, ['']] }
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise routes for Administrator
  devise_for :administrators, path: 'api/v1/administrator', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'api/v1/administrators/sessions',
    registrations: 'api/v1/administrators/registrations',
    invitations: 'api/v1/administrators/invitations'
  }

  # Devise routes for Driver
  devise_for :drivers, path: 'api/v1/driver', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'api/v1/drivers/sessions',
    registrations: 'api/v1/drivers/registrations',
    invitations: 'api/v1/drivers/invitations'
  }

  namespace :api do
    namespace :v1 do
      namespace :administrators do
        resources :teams, only: [:index, :show, :create, :update, :destroy]
        resources :administrators, only: [:index, :show, :update, :destroy]
        resources :organizations, only: [:index, :update, :destroy]
        resources :hubs, only: [:index, :show, :create, :update, :destroy]
        resources :drivers, only: [:index, :show, :update, :destroy]
        resources :tasks, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
