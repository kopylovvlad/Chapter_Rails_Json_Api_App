require 'rails_helper'

RSpec.describe 'Admin::Api::Pages#show', type: :request do
  # checking roles
  include_examples(
    'guest can not :get',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )
  include_examples(
    'applicant can not :get',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )
  include_examples(
    'director can not :get',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )
  include_examples(
    'certificates can not :get',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )

  describe 'admin' do
    it 'should render item' do
      # prepare
      item = FactoryBot.create(:page)
      expect(Page.count).to eq(1)
      sign_in(admin_user)

      # action
      get(
        admin_api_page_path(item),
        headers: json_header,
      )

      # check
      success_response(response)
      expect(json['id']).to eq(item.id)
      expect(json['title']).to eq(item.title)
      expect(json['locator']).to eq(item.locator)
      expect(json['descriptions']).to eq(item.descriptions)
      expect(json['content']).to eq(item.content)
      expect(json['published_at']).to eq(item.published_at.strftime('%Y-%m-%d %H:%M:%S +0000'))
      save_file('admin_api_pages_show', json)
    end

    it 'should return 404' do
      # prepare
      expect(Page.count).to eq(0)
      sign_in(admin_user)

      # action
      get(
        admin_api_page_path(999),
        headers: json_header,
      )

      # check
      not_found_response(response)
      not_found_json(json)
    end
  end
end
