require 'rails_helper'

RSpec.describe 'Api::chapterss#index', type: :request do
  describe 'index with pagination' do
    it 'should return 3 items' do
      # prepare
      FactoryBot.create_list(:chapter, 2, state: 'draft')
      FactoryBot.create_list(:chapter, 3, state: 'on_review')
      expect(Chapter.count).to eq(5)

      # action
      get(
        api_chapters_path,
        headers: json_header,
        params: {
          pagination: { page: 1, per_page: 3 }
        }
      )

      # check
      success_response(response)
      expect(json['chapters'].size).to eq(3)
      expect(json['chapters'][0]['id']).to_not eq(nil)
      check_pagination(json['pagination'])
      save_file('api_chapters_index', json)
    end

    it 'should return empty array' do
      # prepare
      expect(Chapter.count).to eq(0)

      # action
      get(
        api_chapters_path,
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['chapters'].size).to eq(0)
      check_empty_pagination(json['pagination'])
    end
  end
end
