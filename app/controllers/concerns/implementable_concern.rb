# frozen_string_literal: true

module ImplementableConcern
  extend ActiveSupport::Concern

  included do
    before_action :raise_method_not_implemented_error, unless: -> { method_implemented? }
  end

  private

  def method_implemented?
    self.class::IMPLEMENT_METHODS.include?(action_name)
  end

  def raise_method_not_implemented_error
    raise NotImplementedError, "#{self.class.name}##{action_name} is not implemented"
  end
end
