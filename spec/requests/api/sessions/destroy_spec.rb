require 'rails_helper'

RSpec.describe 'Api::Sessions#show', type: :request do
  describe 'auth' do
    it 'should delete session' do
      # prepare
      user1
      user2
      expect(User.count).to eq(2)
      sign_in(user1)

      # action
      delete(
        api_sessions_path,
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['user']).to eq(nil)
    end
  end

  describe 'guest' do
    it 'should delete session' do
      # prepare
      user1
      user2
      expect(User.count).to eq(2)

      # action
      delete(
        api_sessions_path,
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['user']).to eq(nil)
    end
  end
end
