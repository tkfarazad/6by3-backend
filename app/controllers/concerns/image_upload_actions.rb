# frozen_string_literal: true

module ImageUploadActions
  def create
    api_action do |m|
      m.success do |updated_record|
        render jsonapi: updated_record
      end
    end
  end

  alias update create
  alias destroy create
end
