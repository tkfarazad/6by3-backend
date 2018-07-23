# frozen_string_literal: true

module Params
  module Finder
    class Build < BaseOperation
      def call(params, exclude: {})
        {
          filter: params[:filter],
          sort: params[:sort],
          paginate: params[:page],
          exclude: exclude
        }
      end
    end
  end
end
