# frozen_string_literal: true

class DestroyUploadOperation < BaseOperation
  def initialize(owner)
    @owner = owner
  end

  def call(mounted_as:)
    remove_attach(mounted_as)
  end

  private

  attr_reader :owner

  def remove_attach(mounted_as)
    method = "remove_#{mounted_as}!"

    owner.public_send(method) if owner.respond_to?(method)
    owner.save
  end
end
