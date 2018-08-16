# frozen_string_literal: true

resources :videos, only: %i[index show] do
  scope module: :videos do
    resource :view, only: %i[create destroy], controller: :view
  end
end

namespace :videos do
  resources :viewed, only: %i[index], controller: :viewed
  resources :trending, only: %i[index], controller: :trending
end

resources :subscriptions, only: %i[create] do
  scope module: :subscriptions do
    resource :cancel, only: %i[create], controller: :cancel
  end
end

resources :payment_sources, only: %i[create destroy] do
  scope module: :payment_sources do
    resource :make_default, only: %i[create], controller: :make_default
  end
end

resources :plans, only: %i[index]
