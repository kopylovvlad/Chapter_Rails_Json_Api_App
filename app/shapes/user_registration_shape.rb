class UserRegistrationShape < User
  include ApplicationShape
  attr_accessor :password

  validates_confirmation_of :email
  validates_presence_of :password_confirmation
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_confirmation_of :password
end
