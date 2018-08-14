# frozen_string_literal: true

namespace :sockets do
  resource :auth, only: :create, controller: :auth
end
