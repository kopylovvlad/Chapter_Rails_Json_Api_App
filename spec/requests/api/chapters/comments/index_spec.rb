require 'rails_helper'

RSpec.describe 'Api::Chapters::commentss#index', type: :request do
  describe 'index with pagination' do
    it 'should return 3 items' do
      # prepare
      chapter = FactoryBot.create(:chapter)
      FactoryBot.create_list(
        :comment,
        6,
        chapter: chapter
      )
      expect(Comment.count).to eq(6)

      # action
      get(
        api_chapter_comments_path(chapter),
        headers: json_header,
        params: {
          pagination: { page: 1, per_page: 3 }
        }
      )

      # check
      success_response(response)
      expect(json['comments'].size).to eq(3)
      expect(json['comments'][0]['id']).to_not eq(nil)
      check_pagination(json['pagination'])
      save_file('api_chapters_comments_index', json)
    end

    it 'should return empty array' do
      # prepare
      chapter = FactoryBot.create(:chapter)
      expect(Comment.count).to eq(0)

      # action
      get(
        api_chapter_comments_path(chapter),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['comments'].size).to eq(0)
      check_empty_pagination(json['pagination'])
    end
  end
end
