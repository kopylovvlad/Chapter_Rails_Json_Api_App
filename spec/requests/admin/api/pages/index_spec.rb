require 'rails_helper'

RSpec.describe 'Admin::Api::pagess#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_pages_path
  include_examples 'applicant can not :get', :admin_api_pages_path
  include_examples 'director can not :get', :admin_api_pages_path
  include_examples 'certificates can not :get', :admin_api_pages_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:page, 6)
        expect(Page.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_pages_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['pages'].size).to eq(3)
        expect(json['pages'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(Page.count)
        check_pagination(json['pagination'])
        save_file('admin_api_pages_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(Page.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_pages_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['pages'].size).to eq(0)
        expect(json['total_count']).to eq(Page.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:page, title: 'zzz zzz zz zztest')
        FactoryBot.create(:page, title: 'TESTZZ ZZ ZZZ ZZZ')
        FactoryBot.create(:page, title: 'www test wwww test')
        FactoryBot.create(:page, title: 'aa aaaa aaaaaaa')
        expect(Page.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_pages_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['pages'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
