require 'rails_helper'

RSpec.describe 'Api::chapters#create', type: :request do
  describe 'success' do
    it 'should create item' do
      # prepare
      user1
      user2
      count = Chapter.all.count
      sign_in(user1)

      # action
      post(
        api_chapters_path,
        headers: json_header,
        params: {
          chapters:
            {
              title: 'some title',
              body: 'body body',
            }
        }
      )

      # check
      success_response(response)
      expect(json['id']).to_not eq(nil)
      expect(json['title']).to eq('some title')
      expect(json['body']).to eq('body body')
      expect(json['user_id']).to eq(user1.id)
      expect(json['state']).to eq('draft')
      expect(Chapter.all.count).to eq(count + 1)
      save_file('api_chapters_create_success', json)
    end
  end

  describe 'invalid data' do
    it 'should return array with validation errors' do
      # prepare
      count = Chapter.all.count
      sign_in(user1)

      # action
      post(
        api_chapters_path,
        headers: json_header,
        params: {
          chapters: { title: '' }
        }
      )

      # check
      error_response(response)
      expect(json['errors'].present?).to eq(true)
      expect(json['errors'].size).to be > 0
      expect(Chapter.all.count).to eq(count)
      save_file('api_chapters_create_fail', json)
    end
  end

  describe 'without user' do
    it 'should return array with validation errors' do
      # prepare
      user1
      user2
      count = Chapter.all.count

      # action
      post(
        api_chapters_path,
        headers: json_header,
        params: {
          chapters: { active: true }
        }
      )

      # check
      notauth_response(response)
      expect(json['error']).to eq('Unauthorized')
      expect(Chapter.all.count).to eq(count)
      save_file('api_chapters_create_fail', json)
    end
  end

  describe 'params require' do
    it 'should return incorrect_data' do
      # prepare
      user1
      count = Chapter.all.count
      sign_in(user1)

      # action
      post(
        api_chapters_path,
        headers: json_header,
        params: {
          chapters: {}
        }
      )

      # check
      error_response(response)
      error_json
      expect(Chapter.all.count).to eq(count)
    end
  end
end
