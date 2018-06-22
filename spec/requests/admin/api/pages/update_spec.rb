require 'rails_helper'

RSpec.describe 'Admin::Api::Pages#update', type: :request do
  # checking roles
  include_examples(
    'guest can not :patch',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )
  include_examples(
    'applicant can not :patch',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )
  include_examples(
    'director can not :patch',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )
  include_examples(
    'certificates can not :patch',
    :admin_api_page_path,
    FactoryBot.create(:page).id
  )

  let(:item) do
    FactoryBot.create(
      :page,
      title: 'lolo1',
      locator: 'lolo2',
      descriptions: 'lolo3',
      content: 'lolo4',
      published_at: '2018-02-26 08:06:54 +0000'
    )
  end

  describe 'admin' do
    describe 'success' do
      it 'should update item' do
        # prepare
        item
        expect(Page.all.count).to eq(1)
        sign_in(admin_user)
        new_title = Faker::Lorem.words(5).join(' ')
        new_descr = Faker::Lorem.words(8).join(' ')
        new_content = Faker::Lorem.words(12).join(' ')
        new_locator = "#{Faker::Lorem.word}#{Page.count + 1}"
        new_published_at = '2018-03-26 08:06:54 +0000'

        # action
        patch(
          admin_api_page_path(item),
          headers: json_header,
          params: {
            pages:
              {
                title: new_title,
                locator: new_locator,
                descriptions: new_descr,
                content: new_content,
                published_at: new_published_at
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to eq(item.id)
        expect(json['title']).to eq(new_title)
        expect(json['locator']).to eq(new_locator)
        expect(json['descriptions']).to eq(new_descr)
        expect(json['content']).to eq(new_content)
        expect(json['published_at']).to eq(new_published_at)
        expect(Page.all.count).to eq(1)
        save_file('admin_api_pages_update_success', json)
      end
    end

    describe 'invalid item' do
      it 'should return array with validation errors' do
        # prepare
        item
        expect(Page.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_page_path(item),
          headers: json_header,
          params: {
            pages:
              {
                locator: '',
              }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(Page.all.count).to eq(1)
        save_file('admin_api_pages_update_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        item
        expect(Page.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_page_path(item),
          headers: json_header,
          params: {
            pages: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(Page.all.count).to eq(1)
      end
    end

    describe 'does not exist' do
      it 'should return 404' do
        # prepare
        expect(Page.all.count).to eq(0)

        sign_in(admin_user)

        # action
        patch(
          admin_api_page_path(999),
          headers: json_header,
          params: {
            pages: { title: '123' }
          }
        )

        # check
        not_found_response(response)
        expect(Page.all.count).to eq(0)
      end
    end
  end
end
