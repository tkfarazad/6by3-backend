# frozen_string_literal: true

module FFaker
  module Video
    UPLOADED_FILE_NAME = 'video'
    UPLOADED_FILE_EXTENSION = 'mp4'

    CONTENT_TYPE_MAPPER = {
      mp4: 'video/mp4',
      ogv: 'video/ogv'
    }.freeze

    private_constant :UPLOADED_FILE_NAME, :UPLOADED_FILE_EXTENSION, :CONTENT_TYPE_MAPPER

    extend ActionDispatch::TestProcess

    module_function

    def name(dir: nil, name: UPLOADED_FILE_NAME, extension: UPLOADED_FILE_EXTENSION)
      FFaker::Filesystem.file_name(dir, name, extension)
    end

    def file(name: UPLOADED_FILE_NAME, extension: UPLOADED_FILE_EXTENSION)
      fixture_file_upload("spec/fixtures/files/#{name}.#{extension}", CONTENT_TYPE_MAPPER[extension.to_sym])
    end
  end
end
