# frozen_string_literal: true

module Api::V1
  class ApplicationController < ::ApplicationController
    include Knock::Authenticable

    before_action :authenticate_user

    def jsonapi_class
      Hash.new { |h, k| h[k] = "Api::V1::#{k}Serializer".safe_constantize }
    end

    private

    def resolve_action
      [
        self.class.name.deconstantize,
        controller_name.camelize,
        "#{action_name}_action".classify
      ].join("::").constantize
    end

    # rubocop:disable Metrics/AbcSize
    def api_action(context: {}, input: params.to_unsafe_h)
      context = context.reverse_merge(current_user: current_user)

      resolve_action.new(context: context).call(input) do |m|
        yield(m)

        m.failure(:deserialize) do
          head 400
        end

        m.failure(:deserialize_bulk) do
          head 400
        end

        m.failure(:validate) do |errors|
          responds_with_errors(errors, status: 422)
        end

        m.failure(:authorize) do
          head 403
        end

        m.failure(:find) do
          head 404
        end

        m.failure(:find_all) do
          head 404
        end

        m.failure do |errors|
          responds_with_errors(errors, status: 422)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    def responds_with_errors(errors, status:)
      render jsonapi_errors: errors, status: status
    end
  end
end
