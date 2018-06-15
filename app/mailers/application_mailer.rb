# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@6by3.tv'
  layout 'mailer'
end
