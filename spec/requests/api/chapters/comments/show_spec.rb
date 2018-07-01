require 'rails_helper'

RSpec.describe 'Api::Chapters::Comments#show', type: :request do
  it 'should render item' do
    # prepare
    item = FactoryBot.create(:comment)
    expect(Chapter::Comment.count).to eq(1)

    # action
    get(
      api_chapter_comment_path(item.chapter, item),
      headers: json_header,
    )

    # check
    success_response(response)
    expect(json['id']).to eq(item.id)
    expect(json['body']).to eq(item.body)
    expect(json['user_id']).to eq(item.user_id)
    expect(json['chapter_id']).to eq(item.chapter_id)
    save_file('api_chapters_comments_show', json)
  end

  describe 'chapter does not exist' do
    it 'should return 404' do
      # prepare
      expect(Chapter.count).to eq(0)
      expect(Chapter::Comment.count).to eq(0)

      # action
      get(
        api_chapter_comment_path(99, 999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end

  describe 'comment does not exist' do
    it 'should return 404' do
      # prepare
      chapter = FactoryBot.create(:chapter)
      expect(Chapter::Comment.count).to eq(0)

      # action
      get(
        api_chapter_comment_path(chapter, 999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end
end
