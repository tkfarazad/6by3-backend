# frozen_string_literal: true

resources :videos do
  scope module: :videos do
    resource :view, only: :create, controller: :view
  end
end
