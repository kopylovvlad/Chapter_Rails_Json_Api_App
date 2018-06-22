require 'rails_helper'

RSpec.describe 'Admin::Api::userss#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_users_path
  include_examples 'applicant can not :get', :admin_api_users_path
  include_examples 'director can not :get', :admin_api_users_path
  include_examples 'certificates can not :get', :admin_api_users_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:user, 6)
        expect(User.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_users_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['users'].size).to eq(3)
        expect(json['users'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(User.count)
        check_pagination(json['pagination'])
        save_file('admin_api_users_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(User.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_users_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['users'].size).to eq(0)
        expect(json['total_count']).to eq(User.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        # TODO: create 4 items
        # FactoryBot.create(:user, title: 'zzz zzz zz zztest')
        # FactoryBot.create(:user, title: 'TESTZZ ZZ ZZZ ZZZ')
        # FactoryBot.create(:user, title: 'www test wwww test')
        # FactoryBot.create(:user, title: 'aa aaaa aaaaaaa')
        expect(User.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_users_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['users'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
