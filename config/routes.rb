# frozen_string_literal: true

Rails.application.routes.draw do
  current_api_routes = lambda do
    constraints(id: /\d+/) do
      draw :user
      draw :users
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
