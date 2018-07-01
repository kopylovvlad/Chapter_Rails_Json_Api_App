# frozen_string_literal: true

module UserService
  def self.authenticate(user, input_password)
    return false unless user.is_a?(User) and !user.new_record?

    b_crypt = BCrypt::Password.new(user.encrypted_password)
    value = input_password + Rails.application.secrets.secret_key_base.to_s
    b_crypt == value
  end
end
