# frozen_string_literal: true

module UserRegistrationService
  def self.create(params)
    item = UserRegistrationShape.new(params)
    return item unless item.valid?
    UserMutator.create(params)
  end
end
