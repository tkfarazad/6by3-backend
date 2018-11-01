# frozen_string_literal: true

module Api::V1
  class CustomStepAdapters < Dry::Transaction::StepAdapters
    extend Dry::Monads::Result::Mixin

    register :array_map, lambda { |operation, options, args|
      parameters = args[0]

      perform = lambda do
        parameters.each do |arg|
          operation.call(arg)
        end
      end

      if options.fetch(:transaction, false) == true
        Sequel::Model.db.transaction do
          Success(perform.call)
        end
      else
        Success(perform.call)
      end
    }

    register :array_tee, lambda { |operation, _, args|
      parameters = args[0]

      parameters.each do |arg|
        operation.call(arg)
      end

      Success(parameters)
    }
  end
end
