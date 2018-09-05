# frozen_string_literal: true

module Api::V1::Admin
  class BaseController < ::Api::V1::ApplicationController
    include ::ImplementableConcern

    def index
      api_action do |m|
        m.success do |records, meta|
          render jsonapi: records,
                 meta: meta
        end
      end
    end

    def show
      api_action do |m|
        m.success do |record|
          render jsonapi: record
        end
      end
    end

    def create
      api_action do |m|
        m.success do |record|
          render jsonapi: record, status: :created
        end

        yield(m) if block_given?
      end
    end

    def update
      api_action do |m|
        m.success do |updated_record|
          render jsonapi: updated_record
        end
      end
    end

    def destroy
      api_action do |m|
        m.success do
          head :no_content
        end
      end
    end

    def destroy_bulk
      api_action do |m|
        m.success do
          head :no_content
        end
      end
    end
  end
end
