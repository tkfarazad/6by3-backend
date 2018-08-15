# frozen_string_literal: true

resources :videos, only: %i[index show] do
  scope module: :videos do
    resource :view, only: %i[create destroy], controller: :view
  end
end

namespace :videos do
  resources :trending, only: %i[index], controller: :trending
end
