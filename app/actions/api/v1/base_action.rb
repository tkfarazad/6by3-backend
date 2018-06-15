# frozen_string_literal: true

module Api::V1
  class BaseAction
    include Dry::Transaction(container: Container)
    include ::TransactionContext[:current_user]

    private

    def resolve_schema
      [
        self.class.name.deconstantize,
        self.class.name.demodulize.underscore.gsub("_action", "_schema").classify
      ].join("::").constantize
    end

    def resolve_policy
      "#{self.class.name.deconstantize.singularize}Policy".constantize
    end
  end
end
