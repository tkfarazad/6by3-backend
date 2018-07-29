# frozen_string_literal: true

resources :videos, only: %i[index show] do
  scope module: :videos do
    resource :view, only: :create, controller: :view
  end
end

resources :coaches, only: %i[index show]
