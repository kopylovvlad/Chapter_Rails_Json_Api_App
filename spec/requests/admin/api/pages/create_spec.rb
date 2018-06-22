require 'rails_helper'

RSpec.describe 'Admin::Api::pages#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_pages_path
  include_examples 'applicant can not :post', :admin_api_pages_path
  include_examples 'director can not :post', :admin_api_pages_path
  include_examples 'certificates can not :post', :admin_api_pages_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = Page.all.count
        sign_in(admin_user)
        param_title = Faker::Lorem.words(4).join(' ')
        param_descriptions = Faker::Lorem.words(8).join(' ')
        param_content = Faker::Lorem.words(14).join(' ')
        params_locator = "#{Faker::Lorem.word}#{Page.count + 1}"
        right_published_at = '2018-02-26 08:06:54 +0000'
        params_published_at = DateTime.parse(right_published_at)


        # action
        post(
          admin_api_pages_path,
          headers: json_header,
          params: {
            pages:
              {
                title: param_title,
                locator: params_locator,
                descriptions: param_descriptions,
                content: param_content,
                published_at: params_published_at
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['title']).to eq(param_title)
        expect(json['locator']).to eq(params_locator)
        expect(json['descriptions']).to eq(param_descriptions)
        expect(json['content']).to eq(param_content)
        expect(json['published_at']).to eq(right_published_at)
        expect(Page.all.count).to eq(count + 1)
        save_file('admin_api_pages_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = Page.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_pages_path,
          headers: json_header,
          params: {
            pages: { lcoator: '' }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(Page.all.count).to eq(count)
        save_file('admin_api_pages_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = Page.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_pages_path,
          headers: json_header,
          params: {
            pages: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(Page.all.count).to eq(count)
      end
    end
  end
end
