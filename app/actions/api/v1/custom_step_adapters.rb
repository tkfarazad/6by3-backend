# frozen_string_literal: true

module Api::V1
  class CustomStepAdapters < Dry::Transaction::StepAdapters
    extend Dry::Monads::Result::Mixin

    register :array_map, lambda { |operation, _options, args|
      parameters = args[0]

      parameters.each do |arg|
        operation.call(arg)
      end

      Success(parameters)
    }
  end
end
