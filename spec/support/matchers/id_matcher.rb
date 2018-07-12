# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :eq_id do |expected|
  match { |actual| actual == expected.to_s }
end
