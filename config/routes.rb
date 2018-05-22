# frozen_string_literal: true

Rails.application.routes.draw do
  current_api_routes = lambda do
    constraints(id: /\d+/) do
      resource :user, only: [] do
        scope module: :user do
          resources :tokens, only: :create
        end
      end
      resources :users, only: %i[create]
      resource :user, only: %i[show], controller: :user
    end
  end

  namespace :api do
    namespace :v1, &current_api_routes
  end
  scope module: :api do
    namespace :v1, &current_api_routes
  end
end
