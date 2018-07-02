# frozen_string_literal: true

UPLOADED_FILE_NAME = 'video'
UPLOADED_FILE_EXTENSION = 'mp4'

module FFaker
  module Video
    extend ActionDispatch::TestProcess

    module_function

    def name(dir = nil, name = UPLOADED_FILE_NAME, extension = UPLOADED_FILE_EXTENSION)
      FFaker::Filesystem.file_name(dir, name, extension)
    end

    def file(name = UPLOADED_FILE_NAME, extension = UPLOADED_FILE_EXTENSION)
      fixture_file_upload("spec/fixtures/files/#{name}.#{extension}", 'video/mpeg')
    end
  end
end
