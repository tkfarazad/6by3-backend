# frozen_string_literal: true

module FFaker
  module Video
    UPLOADED_FILE_NAME = 'video'
    UPLOADED_FILE_EXTENSION = 'mp4'

    private_constant :UPLOADED_FILE_NAME, :UPLOADED_FILE_EXTENSION

    extend ActionDispatch::TestProcess

    module_function

    def name(dir: nil, name: UPLOADED_FILE_NAME, extension: UPLOADED_FILE_EXTENSION)
      FFaker::Filesystem.file_name(dir, name, extension)
    end
  end
end
