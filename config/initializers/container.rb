# frozen_string_literal: true

class Container
  extend Dry::Container::Mixin

  namespace :customerio do
    register :client, memoize: true do
      Customerio::Client.new(ENV['CUSOMTERIO_SITE_ID'], ENV['CUSOMTERIO_API_SECRET_KEY'])
    end
  end
end
