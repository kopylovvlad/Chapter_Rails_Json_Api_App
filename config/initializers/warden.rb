require 'warden'

Rails.configuration.middleware.use Warden::Manager do |manager|
  manager.scope_defaults :default, strategies: [:password]
  manager.failure_app = proc do
    [
      '401',
      { 'Content-Type' => 'application/json' },
      [{ error: 'Unauthorized' }.to_json]
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
    if AuthUserService.perform(params['email'], params['password'])
      success! user
    else
      fail! 'Oops'
    end
  end
end
