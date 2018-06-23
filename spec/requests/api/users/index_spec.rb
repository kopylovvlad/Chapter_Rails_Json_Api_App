require 'rails_helper'

RSpec.describe 'Api::userss#index', type: :request do
  describe 'index with pagination' do
    it 'should return 3 items' do
      # prepare
      FactoryBot.create_list(:user, 6)
      expect(User.count).to eq(6)

      # action
      get(
        api_users_path,
        headers: json_header,
        params: {
          pagination: { page: 1, per_page: 3 }
        }
      )

      # check
      success_response(response)
      expect(json['users'].size).to eq(3)
      expect(json['users'][0]['id']).to_not eq(nil)
      check_pagination(json['pagination'])
      save_file('api_users_index', json)
    end

    it 'should return empty array' do
      # prepare
      expect(User.count).to eq(0)

      # action
      get(
        api_users_path,
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['users'].size).to eq(0)
      check_empty_pagination(json['pagination'])
    end
  end
end
