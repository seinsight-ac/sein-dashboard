Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions" }, :skip => [:registrations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :dashboards do

    collection do
      get :googleanalytics
      get :facebook
    end

  end

  root "dashboards#index"

end
