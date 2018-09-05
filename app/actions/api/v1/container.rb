# frozen_string_literal: true

module Api
  module V1
    class Container
      extend Dry::Container::Mixin

      namespace 'params' do
        register 'validate' do
          Params::Validate.new
        end

        register 'deserialize' do
          Params::Deserialize.new
        end

        register 'deserialize_bulk' do
          Params::DeserializeBulk.new
        end

        namespace 'finder' do
          register 'build' do
            Params::Finder::Build.new
          end
        end
      end

      namespace 'entity_finder' do
        register 'bulk' do
          EntityFinder::Bulk.new
        end
      end

      namespace 'meta' do
        register 'paginate' do
          MetaBuilder::Paginate.new
        end
      end

      register 'pusher', memoize: true do
        ::Pusher::Client.new(
          app_id: ENV['PUSHER_APP_ID'],
          key: ENV['PUSHER_KEY'],
          secret: ENV['PUSHER_SECRET'],
          cluster: ENV['PUSHER_CLUSTER'],
          encrypted: true
        )
      end
    end
  end
end
