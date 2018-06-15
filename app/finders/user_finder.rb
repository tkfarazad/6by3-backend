# frozen_string_literal: true

class UserFinder
  def initialize(current_user)
    @current_user = current_user
  end

  def call(user_id)
    find_user(user_id)
  end

  private

  attr_reader :current_user

  def find_user(user_id)
    if current_user?(user_id)
      current_user || raise(Sequel::NoMatchingRow)
    else
      User.with_pk!(user_id)
    end
  end

  def current_user?(user_id)
    user_id.nil? && current_user
  end
end
