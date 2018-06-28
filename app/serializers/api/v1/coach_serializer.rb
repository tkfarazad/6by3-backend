# frozen_string_literal: true

module Api::V1
  class CoachSerializer < Api::V1::BaseSerializer
    type 'coaches'

    attributes :fullname,
               :avatar

    attribute :deleted_at, if: -> { current_user_is_admin? }
  end
end
