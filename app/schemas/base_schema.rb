# frozen_string_literal: true

class BaseSchema < Dry::Validation::Schema
  configure do
    config.messages = :i18n

    predicates(::CustomPredicates)
  end
end
