# frozen_string_literal: true

module Api::V1::Sockets::Auth
  CreateSchema = Dry::Validation.Params(BaseSchema) do
    required(:socket_id).filled(:str?)
    required(:channel_name).filled(:valid_channel?)
  end
end
