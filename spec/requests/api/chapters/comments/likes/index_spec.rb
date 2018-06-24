require 'rails_helper'

RSpec.describe 'Api::Chapters::Comments::likes#index', type: :request do
  describe 'index with pagination' do
    it 'should return 3 items' do
      # prepare
      chapter = FactoryBot.create(:chapter)
      comment = FactoryBot.create(
        :comment,
        chapter: chapter
      )
      6.times do
        FactoryBot.create(
          :like,
          user: FactoryBot.create(:user),
          comment: comment
        )
      end
      expect(Like.count).to eq(6)

      # action
      get(
        api_chapter_comment_likes_path(chapter, comment),
        headers: json_header,
        params: {
          pagination: { page: 1, per_page: 3 }
        }
      )

      # check
      success_response(response)
      expect(json['likes'].size).to eq(3)
      expect(json['likes'][0]['id']).to_not eq(nil)
      check_pagination(json['pagination'])
      save_file('api_chapters_comments_likes_index', json)
    end

    it 'should return empty array' do
      # prepare
      chapter = FactoryBot.create(:chapter)
      comment = FactoryBot.create(
        :comment,
        user: FactoryBot.create(:user),
        chapter: chapter
      )
      expect(Like.count).to eq(0)

      # action
      get(
        api_chapter_comment_likes_path(chapter, comment),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['likes'].size).to eq(0)
      check_empty_pagination(json['pagination'])
    end
  end
end
