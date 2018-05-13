# frozen_string_literal: true

module SerializerHelpers
  def serialize_entity(entity, **options)
    JSONAPI::Serializable::Renderer.new.render(entity, options)
  end
end
