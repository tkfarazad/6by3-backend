# frozen_string_literal: true

module Api::V1::User::Relationships::FavoriteCoaches
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    try :create, catch: Sequel::UniqueConstraintViolation

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def create(favorite_coach_pks:)
      ::FavoriteUserCoach.db.transaction do
        favorite_coach_pks.each do |coach_id|
          ::FavoriteUserCoach.create(user_id: current_user.id, coach_id: coach_id)
        end
      end
    end
  end
end
