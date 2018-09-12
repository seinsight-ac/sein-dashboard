Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations],controllers: { omniauth_callbacks: "users/omniauth_callbacks" } 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :dashboards do

    collection do
      get :ga
      get :mailchimp
      get :fb
      get :alexa
    end

  end

  root "dashboards#index"

end
