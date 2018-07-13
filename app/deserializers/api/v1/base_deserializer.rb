# frozen_string_literal: true

module Api::V1
  class BaseDeserializer < JSONAPI::Deserializable::Resource
    key_format(&:underscore)

    id
    type
    attributes
    has_one

    has_many do |_rel, ids, _types, type|
      {
        "#{type.singularize}_pks" => ids
      }
    end
  end
end
