# frozen_string_literal: true

module Params
  module Finder
    class Build < BaseOperation
      def call(params, exclude: {deleted_at: ::SixByThree::Constants::VALUE_PRESENT})
        {
          filter: params[:filter],
          sort: params[:sort],
          page: params[:page],
          exclude: exclude
        }
      end
    end
  end
end
