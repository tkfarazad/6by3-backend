# frozen_string_literal: true

module Api::V1
  class UserSerializer < Api::V1::BaseSerializer
    type 'users'

    attributes :email,
               :avatar,
               :first_name,
               :last_name

    attribute :privacy_policy_accepted, if: -> { current_user_or_admin? }
    attribute :admin, if: -> { current_user_or_admin? }
    attribute :deleted_at, if: -> { current_user_or_admin? }
    attribute :plan_type, if: -> { current_user_is_admin? }
    attribute :city, if: -> { current_user_is_admin? }
    attribute :country, if: -> { current_user_is_admin? }

    has_many :favorite_coaches do
      linkage always: true
    end
    has_many :payment_sources, if: -> { current_user? }
    belongs_to :default_payment_source, if: -> { current_user? }
    has_many :subscriptions, if: -> { current_user_or_admin? }
  end
end
