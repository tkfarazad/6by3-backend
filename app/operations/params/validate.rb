# frozen_string_literal: true

module Params
  class Validate < BaseOperation
    def call(input, schema)
      schema.call(input).to_monad
    end
  end
end
