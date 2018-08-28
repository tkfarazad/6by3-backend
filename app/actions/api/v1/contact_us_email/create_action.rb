# frozen_string_literal: true

module Api::V1::ContactUsEmail
  class CreateAction < ::Api::V1::BaseAction
    try :deserialize, with: 'params.deserialize', catch: JSONAPI::Parser::InvalidDocument
    step :validate, with: 'params.validate'
    tee :send_contact_us_email

    private

    def deserialize(input)
      super(input, skip_validation: true)
    end

    def send_contact_us_email(params)
      ::SendContactUsLetterJob.perform_later(params)
    end
  end
end
