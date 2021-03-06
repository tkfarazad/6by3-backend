# frozen_string_literal: true

module Api::V1
  class BaseAction
    include Dry::Transaction(container: ::Api::V1::Container, step_adapters: CustomStepAdapters)
    include ::TransactionContext[:current_user]

    private

    def validate(input)
      super(input, resolve_schema)
    end

    def authorize(input)
      resolve_policy.new(current_user).to_monad(input, &resolve_policy_action)
    end

    def resolve_schema
      [
        self.class.name.deconstantize,
        self.class.name.demodulize.underscore.gsub('_action', '_schema').classify
      ].join('::').constantize
    end

    def resolve_policy
      "#{self.class.name.deconstantize.singularize}Policy".constantize
    end

    def resolve_policy_action
      self.class.name.demodulize.underscore.gsub('_action', '?').to_sym
    end

    def error(message = nil)
      {parameters: [message]}
    end
  end
end
