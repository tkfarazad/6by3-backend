# frozen_string_literal: true

class Container
  extend Dry::Container::Mixin

  namespace :customerio do
    register :client, memoize: true do
      Customerio::Client.new(ENV['CUSTOMERIO_SITE_ID'], ENV['CUSTOMERIO_API_SECRET_KEY'])
    end

    register :identify_user, memoize: true do
      Customerio::IdentifyUserService.new
    end
  end
end
