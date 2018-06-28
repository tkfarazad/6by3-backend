# frozen_string_literal: true

module Coaches
  class UpdateOperation < BaseOperation
    def initialize(coach)
      @coach = coach
    end

    def call(input)
      update_coach(input)
    end

    private

    attr_reader :coach

    def update_coach(params)
      coach.update(params)
    end
  end
end
