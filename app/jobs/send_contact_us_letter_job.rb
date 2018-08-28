# frozen_string_literal: true

class SendContactUsLetterJob < ApplicationJob
  def perform(params)
    SendContactUsLetterService.new.call(params)
  end
end
