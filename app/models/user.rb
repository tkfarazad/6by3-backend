# frozen_string_literal: true

class User < Sequel::Model
  plugin :secure_password, include_validations: false
  plugin :association_pks
  plugin :sc_billing_stripe

  mount_uploader :avatar, AvatarUploader

  one_to_many :video_views
  many_to_many :favorite_coaches,
               class_name: 'Coach',
               join_table: :favorite_user_coaches,
               right_key: :coach_id,
               delay_pks: :always

  def self.from_token_payload(payload)
    find(id: payload.fetch('sub'))
  end
end
