# frozen_string_literal: true

resources :subscriptions, only: %i[create] do
  scope module: :subscriptions do
    resource :cancel, only: %i[create], controller: :cancel
  end
end
