# frozen_string_literal: true

resources :payment_sources, only: %i[create destroy] do
  scope module: :payment_sources do
    resource :make_default, only: %i[create], controller: :make_default
  end
end
