# frozen_string_literal: true

module Helpers
  def parsed_body
    if respond_to?(:response_body)
      JSON.parse(response_body)
    else
      JSON.parse(response.body)
    end
  end
end
