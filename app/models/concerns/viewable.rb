# frozen_string_literal: true

module Viewable
  module Viewable
    def viewed_by?(id)
      !views_dataset.where(user_id: id).empty?
    end
  end
end
