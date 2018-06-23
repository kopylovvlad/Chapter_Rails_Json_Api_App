require 'rails_helper'

RSpec.describe 'Api::sessions#create', type: :request do
  describe 'success' do
    it 'should create session' do
      # prepare
      user1
      user2
      expect(User.count).to eq(2)

      # action
      post(
        api_sessions_path,
        headers: json_header,
        params: user1_auth_params
      )

      # check
      success_response(response)
      expect(json['user']['id']).to eq(user1.id)
      expect(json['user']['email']).to eq(user1.email)
      expect(json['user']['login']).to eq(user1.login)
      save_file('api_sessions_create_success', json)
    end
  end

  describe 'invalid data' do
    it 'should return array with validation errors' do
      # prepare
      user1
      user2
      expect(User.count).to eq(2)

      # action
      post(
        api_sessions_path,
        headers: json_header,
        params: user1_auth_params.merge(password: '=)')
      )

      # check
      notauth_response(response)
      expect(json['error']).to eq('Unauthorized')
      save_file('api_sessions_create_fail', json)
    end
  end
end
