# frozen_string_literal: true

class SoftDestroyEntityOperation < BaseOperation
  def initialize(record)
    @record = record
  end

  def call
    hide_record
  end

  private

  attr_reader :record

  def hide_record
    record.update(deleted_at: Time.current)
  end
end
