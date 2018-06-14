# frozen_string_literal: true

module Helpers
  def parsed_body
    if respond_to?(:response_body)
      JSON.parse(response_body, symbolize_names: true)
    else
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
