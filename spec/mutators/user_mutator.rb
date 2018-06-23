require 'rails_helper'

RSpec.describe UserMutator, type: :model do
  let(:input_params) do
    {
      email: 'sfsaf@tmail.com',
      email_confirmation: 'sfsaf@tmail.com',
      login: 'zzzzz',
      password: 'secret',
      password_confirmation: 'secret'
    }
  end

  it 'should create an user' do
    # prepare
    expect(User.count).to eq(0)

    # action
    item = UserMutator.create(input_params)

    # check
    expect(item.valid?).to eq(true)
    expect(item.errors.present?).to eq(false)
    expect(User.count).to eq(1)
  end

  it 'should save password' do
    # prepare
    item = UserMutator.create(input_params)

    # action
    answer = AuthUserService.perform(item, input_params[:password])

    # check
    expect(answer).to eq(true)
  end
end
