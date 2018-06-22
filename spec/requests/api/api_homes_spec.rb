require 'rails_helper'

RSpec.describe 'Api::Home', type: :request do
  describe '404' do
    it 'should returns 404 status' do
      get(
        '/api/sdfsfasdasdasdasdadasd',
        headers: json_header
      )

      not_found_response(response)
      expect(json['error']).to eq('Not found')
    end

    it 'should always returns json' do
      get '/api/sdfsfasdasdasdasdadasd'

      not_found_response(response)
      expect(json['error']).to eq('Not found')
    end
  end

  describe 'api_current_user' do
    it 'should show auth user' do
      # prepare
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      sign_in user2

      # action
      get(
        api_current_user_path,
        headers: json_header
      )

      success_response(response)
      expect(json['current']).to_not eq(nil)
      expect(json['current']['id']).to eq(user2.id)
      expect(json['current']['id']).to_not eq(user1.id)
    end

    it 'should show nil for guest' do
      get(
        api_current_user_path,
        headers: json_header
      )

      success_response(response)
      expect(json['current']).to eq(nil)
    end
  end
end
