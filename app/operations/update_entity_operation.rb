# frozen_string_literal: true

class UpdateEntityOperation < BaseOperation
  def initialize(record)
    @record = record
  end

  def call(input)
    update_record(input)
  end

  private

  attr_reader :record

  def update_record(params)
    record.set(params).save
  end
end
