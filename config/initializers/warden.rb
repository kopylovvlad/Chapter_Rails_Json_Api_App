require 'warden'

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.scope_defaults :default, strategies: [:password]
  manager.failure_app = proc do
    [
      '401',
      { 'Content-Type' => 'application/json' },
      [{ success: false, error: 'Unauthorized' }.to_json]
    ]
  end
end

Warden::Manager.serialize_into_session(&:id)
Warden::Manager.serialize_from_session { |id| User.find(id) }
Warden::Strategies.add(:password) do
  def valid?
    params['email'] || params['password']
  end

  def authenticate!
    user = User.find_by(email: params['email'])
    if AuthUserService.perform(user, params['password'])
      success! user
    else
      fail! 'Oops'
    end
  end
end
