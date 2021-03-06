# frozen_string_literal: true

module PasswordEncryptor
  include BCrypt

  def self.call(password)
    Password.create(password + Rails.application.secrets.secret_key_base.to_s)
  end
end
