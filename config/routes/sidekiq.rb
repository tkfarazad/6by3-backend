# frozen_string_literal: true

require 'sidekiq/web'

if Rails.env.production? || Rails.env.staging?
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking
    secure_compare = lambda do |input, value|
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(input),
        ::Digest::SHA256.hexdigest(value)
      )
    end

    secure_compare.call(username, ENV.fetch('SIDEKIQ_USERNAME')) &
      secure_compare.call(password, ENV.fetch('SIDEKIQ_PASSWORD'))
  end
end
mount Sidekiq::Web, at: '/sidekiq'
