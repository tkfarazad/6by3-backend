# frozen_string_literal: true

module Api::V1::PaymentSources
  class CreateAction < ::Api::V1::BaseAction
    CUSTOMERIO_EVENT = 'card-added'

    map :deserialize, with: 'params.deserialize'
    step :validate, with: 'params.validate'
    step :create
    tee :enqueue_jobs

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def create(token:)
      ::SC::Billing::Stripe::PaymentSources::CreateOperation.new.call(current_user, token).to_result
    end

    def enqueue_jobs
      ::Customerio::IdentifyUserJob.perform_later(user_id: current_user.id)
      ::Customerio::TrackJob.perform_later(user_id: current_user.id, event: CUSTOMERIO_EVENT)
    end
  end
end
