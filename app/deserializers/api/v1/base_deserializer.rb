# frozen_string_literal: true

module Api::V1
  class BaseDeserializer < JSONAPI::Deserializable::Resource
    key_format(&:underscore)

    id
    type
    attributes
    has_many
    has_one
  end
end
