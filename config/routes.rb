Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions" }, :skip => [:registrations]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

  resources :dashboards do

    collection do
      get :googleanalytics
      get :facebook
      get :excel
      get :exceldate
    end

  end

  root "dashboards#index"

end
