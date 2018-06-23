require 'rails_helper'

RSpec.describe UserRegistrationShape, type: :model do
  describe 'all params are valid' do
    it 'should be valid' do
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: 'sfsaf@tmail.com',
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: 'secret'
      }
      item = UserRegistrationShape.new(params)

      expect(item.valid?).to eq(true)
    end
  end

  describe 'password is not confirmate' do
    it 'should not be valid' do
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: 'sfsaf@tmail.com',
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: ''
      }
      item = UserRegistrationShape.new(params)

      expect(item.valid?).to eq(false)
    end
  end

  describe 'password is not exist' do
    it 'should not be valid' do
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: 'sfsaf@tmail.com',
        login: 'zzzzz'
      }
      item = UserRegistrationShape.new(params)

      expect(item.valid?).to eq(false)
    end
  end

  describe 'email is not confirmate' do
    it 'should not be valid' do
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: '',
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: 'secret'
      }
      item = UserRegistrationShape.new(params)

      expect(item.valid?).to eq(false)
    end
  end

  describe 'without email' do
    it 'should not be valid' do
      params = {
        login: 'zzzzz',
        password: 'secret',
        password_confirmation: 'secret'
      }
      item = UserRegistrationShape.new(params)

      expect(item.valid?).to eq(false)
    end
  end

  describe 'without login' do
    it 'should not be valid' do
      params = {
        email: 'sfsaf@tmail.com',
        email_confirmation: 'sfsaf@tmail.com',
        password: 'secret',
        password_confirmation: 'secret'
      }
      item = UserRegistrationShape.new(params)

      expect(item.valid?).to eq(false)
    end
  end
end
