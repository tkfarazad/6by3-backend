# frozen_string_literal: true

module TransactionContext
  # rubocop:disable Metrics/MethodLength
  def self.[](*dependencies)
    Module.new do
      attr_reader :context

      def initialize(context: {}, **opts)
        @context = context
        super
      end

      dependencies.each do |dependency|
        define_method(dependency) do
          context.fetch(dependency)
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
