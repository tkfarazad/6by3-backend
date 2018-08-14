# frozen_string_literal: true

module Api::V1::Sockets::Auth
  class CreateAction < ::Api::V1::BaseAction
    step :validate, with: 'params.validate'
    step :authorize
    try :authenticate_channel, catch: Pusher::Error

    private

    def authorize(params)
      resolve_policy.new(current_user, params).to_monad(params, &resolve_policy_action)
    end

    def authenticate_channel(params)
      ::PusherService.authenticate_channel(params)
    end
  end
end
