# frozen_string_literal: true

class BaseUploader < CarrierWave::Uploader::Base
  def store_dir
    raise ArgumentError, 'Provide directory where files will be stored'
  end

  def extension_whitelist
    raise ArgumentError, 'Provide available file extensions'
  end

  def size_range
    raise ArgumentError, 'Provide minimum and maximum file size range'
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  private

  def secure_token
    var = :"@#{mounted_as}_secure_token"

    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end
