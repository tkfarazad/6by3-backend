# frozen_string_literal: true

class BasePhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    raise ArgumentError, 'Provide directory where files will be stored'
  end

  def extension_whitelist
    raise ArgumentError, 'Provide available photo extensions'
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def size_range
    1..2.megabytes
  end

  private

  def secure_token
    var = :"@#{mounted_as}_secure_token"

    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end
