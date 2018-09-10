Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" } 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :dashboards do

    collection do
      get :ga
      get :mailchimp
<<<<<<< HEAD
      get :fb
=======
      get :alexa
>>>>>>> b7eaa6b144a1f9b98716003757d4c01d247b3b4a
    end

  end

  root "dashboards#index"

end
