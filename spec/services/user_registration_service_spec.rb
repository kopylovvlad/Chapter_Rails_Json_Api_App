require 'rails_helper'

RSpec.describe UserRegistrationService, type: :model do
  describe 'all params are valid' do
    it 'should create an user' do
      expect(User.count).to eq(0)
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: 'sfsaf@tmail.com',
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: 'secret'
      }
      item = UserRegistrationService.create(params)

      expect(item.valid?).to eq(true)
      expect(item.errors.size).to eq(0)
      expect(User.count).to eq(1)
    end
  end

  describe 'without email confirmation' do
    it 'should not create an user' do
      expect(User.count).to eq(0)
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: '',
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: 'secret'
      }
      item = UserRegistrationService.create(params)

      expect(item.valid?).to eq(false)
      expect(item.errors.size).to be > 0
      expect(User.count).to eq(0)
    end
  end

  describe 'with wrong email confirmation' do
    it 'should not create an user' do
      expect(User.count).to eq(0)
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: 'somethin_another',
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: 'secret'
      }
      item = UserRegistrationService.create(params)

      expect(item.valid?).to eq(false)
      expect(item.errors.size).to be > 0
      expect(User.count).to eq(0)
    end
  end

  describe 'without password confirmation' do
    it 'should not create an user' do
      expect(User.count).to eq(0)
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: 'sfsaf@tmail.com',
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: ''
      }
      item = UserRegistrationService.create(params)

      expect(item.valid?).to eq(false)
      expect(item.errors.size).to be > 0
      expect(User.count).to eq(0)
    end
  end
end
