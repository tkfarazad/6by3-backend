# frozen_string_literal: true

class FavoriteUserCoach < Sequel::Model
  many_to_one :coach
  many_to_one :user
end
