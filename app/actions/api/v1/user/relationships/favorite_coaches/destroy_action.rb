# frozen_string_literal: true

module Api::V1::User::Relationships::FavoriteCoaches
  class DestroyAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    map :find_coaches
    map :destroy

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def find_coaches(favorite_coach_pks:)
      ::FavoriteUserCoach.where(user_id: current_user.id, coach_id: favorite_coach_pks)
    end

    def destroy(coaches)
      coaches.destroy
    end
  end
end
