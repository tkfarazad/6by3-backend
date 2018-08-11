# frozen_string_literal: true

module Helpers
  module Json
    def parsed_body
      if respond_to?(:response_body)
        JSON.parse(response_body, symbolize_names: true)
      else
        JSON.parse(response.body, symbolize_names: true)
      end
    end

    def jsonapi_params(type: nil, attributes: {})
      {
        _jsonapi: {
          data: {
            type: type,
            attributes: attributes
          }
        }
      }.with_indifferent_access
    end
  end

  module Server
    def config
      @config ||= {
        Port: 3000,
        DocumentRoot: "#{fixture_path}/videos",
        Logger: WEBrick::Log.new(File.open(File::NULL, 'w')),
        AccessLog: []
      }
    end

    def start_web_server
      @server = WEBrick::HTTPServer.new(config)

      @server.mount_proc '/video.mp4' do |_, response|
        response.body = file_fixture('video.mp4').read
        response.status = 200
      end

      Thread.new { @server.start }
    end

    def stop_web_server
      @server.shutdown
    end
  end

  module Fixtures
    def fixture_path
      @fixture_path ||= File.join(File.dirname(__FILE__), 'fixtures', 'files')
    end
  end
end
