# frozen_string_literal: true

module Avatar
  class DestroyOperation < BaseOperation
    def initialize(owner)
      @owner = owner
    end

    def call
      remove_avatar
    end

    private

    attr_reader :owner

    def remove_avatar
      owner.remove_avatar!
      owner.save
    end
  end
end
