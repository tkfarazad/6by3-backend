# frozen_string_literal: true

module ShowableConcern
  def index
    api_action do |m|
      m.success do |records, meta = {}|
        render jsonapi: records,
               meta: meta
      end
    end
  end

  alias show index
end
