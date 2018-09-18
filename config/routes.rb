Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions" }, :skip => [:registrations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :dashboards do

    collection do
      get :ga
      get :mailchimp
      get :facebook
      get :alexa
    end

  end

  root "dashboards#index"

end
