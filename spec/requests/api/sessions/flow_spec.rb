require 'rails_helper'

RSpec.describe 'Api::sessions#flow', type: :request do
  describe 'auth flow' do
    it 'should work' do
      # prepare
      user1
      user2
      expect(User.count).to eq(2)

      #
      # create session
      post(
        api_sessions_path,
        headers: json_header,
        params: user1_auth_params
      )
      success_response(response)
      expect(json['user']['id']).to eq(user1.id)
      expect(json['user']['email']).to eq(user1.email)
      expect(json['user']['login']).to eq(user1.login)

      #
      # show current session
      get(
        current_api_sessions_path,
        headers: json_header,
      )
      success_response(response)
      expect(json['user']['id']).to eq(user1.id)
      expect(json['user']['login']).to eq(user1.login)
      expect(json['user']['email']).to eq(user1.email)

      #
      # destroy session
      delete(
        api_sessions_path,
        headers: json_header,
      )
      success_response(response)
      expect(json['user']).to eq(nil)

      #
      # show current session
      get(
        current_api_sessions_path,
        headers: json_header,
      )
      success_response(response)
      expect(json['user']).to eq(nil)
    end
  end
end
