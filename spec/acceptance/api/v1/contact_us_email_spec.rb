# frozen_string_literal: true

RSpec.describe 'Contact Us' do
  resource 'Contact Us email request' do
    route '/api/v1/contact_us', 'Send contact us email' do
      post 'Contact us' do
        with_options scope: %i[data attributes], with_example: true do
          parameter :name, FFaker::Name.name, required: true, type: :string
          parameter :email, FFaker::Internet.email, required: true, type: :string
          parameter :message, FFaker::Book.description, required: true, type: :string
        end

        let(:name) { FFaker::Name.name }
        let(:email) { FFaker::Internet.email }
        let(:message) { FFaker::Book.description }

        context 'when emails exists' do
          example 'Responds with 200' do
            do_request

            expect(status).to eq(200)
          end
        end
      end
    end
  end
end
