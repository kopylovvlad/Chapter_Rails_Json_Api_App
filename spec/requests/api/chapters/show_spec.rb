require 'rails_helper'

RSpec.describe 'Api::Chapters#show', type: :request do
  it 'should render item' do
    # prepare
    item = FactoryBot.create(:chapter)
    expect(Chapter.count).to eq(1)

    # action
    get(
      api_chapter_path(item),
      headers: json_header,
    )

    # check
    success_response(response)
    expect(json['id']).to eq(item.id)
    expect(json['title']).to eq(item.title)
    expect(json['body']).to eq(item.body)
    expect(json['user_id']).to eq(item.user_id)
    save_file('api_chapters_show', json)
  end

  it 'should return 404' do
    # prepare
    expect(Chapter.count).to eq(0)

    # action
    get(
      api_chapter_path(999),
      headers: json_header,
    )

    # check
    not_found_response(response)
    not_found_json(json)
  end
end
