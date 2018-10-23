# frozen_string_literal: true

module Types
  include Dry::Types.module

  Coupon = Types::String.constructor do |str|
    str ? str.strip.chomp : str
  end
end
