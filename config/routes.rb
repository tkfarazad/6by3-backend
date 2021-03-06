# frozen_string_literal: true

Rails.application.routes.draw do
  mount SC::Webhooks::Engine => '/'

  concern :avatarable do
    resource :avatar, only: %i[create update destroy], controller: :avatar
  end

  current_api_routes = lambda do
    constraints(id: /\d+/) do
      draw :admin
      draw :user
      draw :users
      draw :public
      draw :private
      draw :pusher

      resource :contact_us, only: :create, controller: :contact_us_email
      resource :confirm_email, only: :create, controller: :confirm_email
      resource :resend_confirm_email, only: :create, controller: :resend_confirm_email
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
