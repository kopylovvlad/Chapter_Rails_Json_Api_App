require 'rails_helper'

RSpec.describe 'Api::registrations#create', type: :request do
  describe 'success' do
    it 'should create item' do
      # prepare
      count = User.all.count

      # action
      post(
        api_registrations_path,
        headers: json_header,
        params: {
          users: {
            email: '12sfsaf@tmail.com',
            email_confirmation: '12sfsaf@tmail.com',
            login: 'zzzzz12',
            password: 'secret',
            password_confirmation: 'secret'
          }
        }
      )

      # check
      success_response(response)
      expect(json['id']).to_not eq(nil)
      expect(json['email']).to eq('12sfsaf@tmail.com')
      expect(json['login']).to eq('zzzzz12')
      expect(User.all.count).to eq(count + 1)
      save_file('api_registrations_create_success', json)
    end
  end

  describe 'invalid data' do
    it 'should return array with validation errors' do
      # prepare
      count = User.all.count

      # action
      post(
        api_registrations_path,
        headers: json_header,
        params: {
          users: { email: '' }
        }
      )

      # check
      error_response(response)
      expect(json['errors'].present?).to eq(true)
      expect(json['errors'].size).to be > 0
      expect(User.all.count).to eq(count)
      save_file('api_registrations_create_fail', json)
    end
  end

  describe 'params require' do
    it 'should return incorrect_data' do
      # prepare
      count = User.all.count

      # action
      post(
        api_registrations_path,
        headers: json_header,
        params: {
          users: {}
        }
      )

      # check
      error_response(response)
      error_json
      expect(User.all.count).to eq(count)
    end
  end
end
