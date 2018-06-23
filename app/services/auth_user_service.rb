module AuthUserService
  def self.perform(user_email, input_password)
    user = User.where(email: user_email).first
    return false unless user.is_a?(User) and !user.new_record?

    b_crypt = BCrypt::Password.new(user.crypted_password)
    b_crypt == input_password
  end
end
