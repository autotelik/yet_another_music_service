# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@autotelik.co.uk'
  layout 'mailer'
end
