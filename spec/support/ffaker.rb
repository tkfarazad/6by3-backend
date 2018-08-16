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

  module Social
    BASE_FACEBOOK_URL = 'https://www.facebook.com'
    BASE_TWITTER_URL = 'https://www.twitter.com'
    BASE_INSTAGRAM_URL = 'https://www.instagram.com'
    BASE_LINKEDIN_URL = 'https://www.linkedin.com'

    private_constant :BASE_FACEBOOK_URL, :BASE_TWITTER_URL, :BASE_INSTAGRAM_URL, :BASE_LINKEDIN_URL

    module_function

    def user_name
      FFaker::InternetSE.user_name
    end

    def facebook
      "#{BASE_FACEBOOK_URL}/#{user_name}"
    end

    def twitter
      "#{BASE_TWITTER_URL}/#{user_name}"
    end

    def instagram
      "#{BASE_INSTAGRAM_URL}/#{user_name}"
    end

    def linkedin
      "#{BASE_LINKEDIN_URL}/#{user_name}"
    end

    def website
      FFaker::Internet.http_url
    end
  end
end
