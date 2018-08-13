# frozen_string_literal: true

module Api::V1
  class CoachSerializer < Api::V1::BaseSerializer
    type 'coaches'

    attributes :avatar,
               :fullname,
               :personal_info,
               :certifications,
               :featured

    attribute :deleted_at, if: -> { current_user_is_admin? }

    has_many :categories do
      linkage always: true
    end
  end
end
