class UserMutator
  def self.create(params)
    encrypted_password = PasswordEncryptor.call(params[:password])

    valid_params = {
      email: params[:email],
      login: params[:login],
      encrypted_password: encrypted_password
    }

    User.create(valid_params)
  end
end
