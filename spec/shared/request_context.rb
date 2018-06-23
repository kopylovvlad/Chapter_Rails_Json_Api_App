RSpec.shared_context 'request_shared_context', shared_context: :metadata do
  let(:user1) do
    FactoryBot.create(
      :user,
      email: 'user1email@tmail.com',
      encrypted_password: PasswordEncryptor.call('super_pass')
    )
  end

  let(:user2) do
    FactoryBot.create(
      :user,
      email: 'user2email@tmail.com',
      encrypted_password: PasswordEncryptor.call('lololo')
    )
  end

  let(:user1_auth_params) do
    {
      email: 'user1email@tmail.com',
      password: 'super_pass'
    }
  end

  def not_found_json(json)
    expect(json['error']).to eq('Not found')
  end
end

RSpec.configure do |rspec|
  rspec.include_context 'request_shared_context', include_shared: true
end
