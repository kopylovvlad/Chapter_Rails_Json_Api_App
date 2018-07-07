require 'rails_helper'

RSpec.describe 'Api::Users::chapters#index', type: :request do
  describe 'index with pagination' do
    it 'should return 2 items for current_user' do
      # prepare
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:chapter, 4)
      FactoryBot.create_list(:chapter, 2, user: user)
      expect(Chapter.count).to eq(6)
      expect(user.chapters.count).to eq(2)
      sign_in(user)

      # action
      get(
        api_user_chapters_path(user),
        headers: json_header,
        params: {
          pagination: { page: 1, per_page: 99 }
        }
      )

      # check
      success_response(response)
      expect(json['chapters'].size).to eq(2)
      expect(json['chapters'][0]['id']).to_not eq(nil)
      check_pagination(json['pagination'])
      save_file('api_users_chapters_index', json)
    end

    it 'should return empty array' do
      # prepare
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:chapter, 2)
      expect(Chapter.count).to eq(2)
      expect(user.chapters.count).to eq(0)
      sign_in(user)

      # action
      get(
        api_user_chapters_path(user),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['chapters'].size).to eq(0)
      check_empty_pagination(json['pagination'])
    end
  end

  describe 'another user' do
    it 'should return forbidden' do
      # prepare
      user1 = FactoryBot.create(:user)
      user2 = FactoryBot.create(:user)
      FactoryBot.create_list(:chapter, 2, user: user1)
      sign_in(user2)

      # action
      get(
        api_user_chapters_path(user1),
        headers: json_header,
      )

      # check
      forbidden_response(response)
    end
  end

  describe 'guest' do
    it 'should return forbidden' do
      # prepare
      user1 = FactoryBot.create(:user)
      FactoryBot.create_list(:chapter, 2, user: user1)

      # action
      get(
        api_user_chapters_path(user1),
        headers: json_header,
      )

      # check
      forbidden_response(response)
    end
  end
end
