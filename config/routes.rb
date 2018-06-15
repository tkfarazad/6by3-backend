# frozen_string_literal: true

Rails.application.routes.draw do
  current_api_routes = lambda do
    constraints(id: /\d+/) do
      draw :admin
      draw :user
      draw :users

      resource :confirm_email, only: :create, controller: :confirm_email
      resource :reset_password, only: :create, controller: :reset_password
      resource :change_password, only: :create, controller: :change_password
    end
  end

  namespace :api do
    namespace :v1, &current_api_routes
  end
  scope module: :api do
    namespace :v1, &current_api_routes
  end

  resource :status, only: %i[show]

  draw :sidekiq
end
