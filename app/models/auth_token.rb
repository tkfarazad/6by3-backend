# frozen_string_literal: true

class AuthToken < Sequel::Model
  many_to_one :user
end
