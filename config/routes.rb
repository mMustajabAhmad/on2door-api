Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get '/icon.png', to: proc { [204, {}, ['']] }
  get "up" => "rails/health#show", as: :rails_health_check

  Rails.application.routes.draw do
    devise_for :administrators, path: 'administrator', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'administrators/sessions',
      registrations: 'administrators/registrations'  
    }

    devise_for :drivers, path: 'driver', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'drivers/sessions',
      registrations: 'drivers/registrations'  
    }
  end


  # Defines the root path route ("/")
  # root "posts#index"
end
