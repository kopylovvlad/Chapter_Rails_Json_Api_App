module PasswordEncryptor
  include BCrypt

  def self.call(password)
    Password.create(password)
  end
end
