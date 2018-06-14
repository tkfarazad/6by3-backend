# frozen_string_literal: true

class StatusesController < ActionController::Metal
  def show
    self.status = 200
  end
end
