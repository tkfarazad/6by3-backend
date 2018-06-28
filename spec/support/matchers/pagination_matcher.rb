# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_paginated_resource_meta do |_|
  match do |actual|
    expect(actual).to include(:current_page, :next_page, :prev_page, :page_count, :record_count)
  end
end
