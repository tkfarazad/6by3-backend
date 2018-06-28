# frozen_string_literal: true

module Api::V1::Admin
  class BaseController < ::Api::V1::ApplicationController
    before_action :raise_method_not_implemented_error, unless: -> { method_implemented }

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

    private

    def method_implemented
      self.class::IMPLEMENT_METHODS == :ALL || self.class::IMPLEMENT_METHODS.include?(action_name)
    end

    def raise_method_not_implemented_error
      raise NotImplementedError, "#{self.class.name}##{action_name} is not implemented"
    end
  end
end
