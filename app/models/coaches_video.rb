# frozen_string_literal: true

class CoachesVideo < Sequel::Model
  many_to_one :coach
  many_to_one :video
end
