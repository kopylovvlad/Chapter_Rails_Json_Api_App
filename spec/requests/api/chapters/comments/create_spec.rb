require 'rails_helper'

RSpec.describe 'Api::Chapters::comments#create', type: :request do
  describe 'success' do
    it 'should create item' do
      # prepare
      user1
      user2
      count = Chapter::Comment.all.count
      chapter = FactoryBot.create(:chapter)
      sign_in(user1)

      # action
      post(
        api_chapter_comments_path(chapter),
        headers: json_header,
        params: {
          comments:
            {
              body: 'lolo asads'
            }
        }
      )

      # check
      success_response(response)
      expect(json['id']).to_not eq(nil)
      expect(json['body']).to eq('lolo asads')
      expect(json['chapter_id']).to eq(chapter.id)
      expect(json['user_id']).to eq(user1.id)
      expect(Chapter::Comment.all.count).to eq(count + 1)
      save_file('api_chapters_comments_create_success', json)
    end
  end

  describe 'guest' do
    it 'should return noauth' do
      # prepare
      user1
      count = Chapter::Comment.all.count
      chapter = FactoryBot.create(:chapter)

      # action
      post(
        api_chapter_comments_path(chapter),
        headers: json_header,
        params: {
          comments:
            {
              body: 'lolo asads'
            }
        }
      )

      # check
      notauth_response(response)
      expect(json['error']).to eq('Unauthorized')
      expect(Chapter::Comment.all.count).to eq(count)
    end
  end

  describe 'invalid data' do
    it 'should return array with validation errors' do
      # prepare
      count = Chapter::Comment.all.count
      user1
      count = Chapter::Comment.all.count
      chapter = FactoryBot.create(:chapter)
      sign_in(user1)

      # action
      post(
        api_chapter_comments_path(chapter),
        headers: json_header,
        params: {
          comments: { body: '' }
        }
      )

      # check
      error_response(response)
      expect(json['errors'].present?).to eq(true)
      expect(json['errors'].size).to be > 0
      expect(Chapter::Comment.all.count).to eq(count)
      save_file('api_chapters_comments_create_fail', json)
    end
  end

  describe 'params require' do
    it 'should return incorrect_data' do
      # prepare
      count = Chapter::Comment.all.count
      # prepare
      user1
      count = Chapter::Comment.all.count
      chapter = FactoryBot.create(:chapter)
      sign_in(user1)

      # action
      post(
        api_chapter_comments_path(chapter),
        headers: json_header,
        params: {
          comments: {}
        }
      )

      # check
      error_response(response)
      error_json
      expect(Chapter::Comment.all.count).to eq(count)
    end
  end
end
