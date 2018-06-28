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
      end

      namespace 'meta' do
        register 'paginate' do
          MetaBuilder::Paginate.new
        end
      end
    end
  end
end
