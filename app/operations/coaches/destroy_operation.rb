# frozen_string_literal: true

module Coaches
  class DestroyOperation < BaseOperation
    def initialize(coach)
      @coach = coach
    end

    def call
      hide_coach
    end

    private

    attr_reader :coach

    def hide_coach
      coach.update(deleted_at: Time.current)
    end
  end
end
