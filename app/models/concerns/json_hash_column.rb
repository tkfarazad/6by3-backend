# frozen_string_literal: true

module JsonHashColumn
  # Defines method for merge jsonb hash column old values with new
  #
  # @example:
  #   class User
  #     extend JsonHashColumn
  #
  #     json_hash_column :settings
  #   end
  def json_hash_column(name)
    define_method("#{name}=") do |value|
      old_value = public_send(name) || {}
      self[name] = old_value.merge(value.transform_keys(&:to_s))
    end
  end
end
