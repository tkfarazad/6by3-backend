# frozen_string_literal: true

class VideoView < Sequel::Model
  many_to_one :user
  many_to_one :video
end
