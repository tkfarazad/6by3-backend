# frozen_string_literal: true

class VideoCategory < Sequel::Model
  one_to_many :videos, key: :category_id
end
