require 'rails_helper'

RSpec.describe 'Api::Sessions#show', type: :request do
  describe 'auth' do
    it 'should show session' do
      # prepare
      user1
      user2
      expect(User.count).to eq(2)
      sign_in(user2)

      # action
      get(
        current_api_sessions_path,
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['user']['id']).to eq(user2.id)
      expect(json['user']['login']).to eq(user2.login)
      expect(json['user']['email']).to eq(user2.email)
      save_file('api_sessions_show', json)
    end
  end

  describe 'guest' do
    it 'should return nil' do
      # prepare
      user1
      user2
      expect(User.count).to eq(2)

      # action
      get(
        current_api_sessions_path,
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['user']).to eq(nil)
    end
  end
end
