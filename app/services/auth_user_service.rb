module AuthUserService
  def self.perform(user, input_password)
    return false unless user.is_a?(User) and !user.new_record?

    b_crypt = BCrypt::Password.new(user.encrypted_password)
    b_crypt == input_password
  end
end
