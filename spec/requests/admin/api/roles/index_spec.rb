require 'rails_helper'

RSpec.describe 'Admin::Api::roless#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_roles_path
  include_examples 'applicant can not :get', :admin_api_roles_path
  include_examples 'director can not :get', :admin_api_roles_path
  include_examples 'certificates can not :get', :admin_api_roles_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 2 items' do
        # prepare
        FactoryBot.create(:role)
        FactoryBot.create(:role_admin)
        FactoryBot.create(:role_dir)
        FactoryBot.create(:role_cert_admin)
        expect(Role.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_roles_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 2 }
          }
        )

        # check
        success_response(response)
        expect(json['roles'].size).to eq(2)
        expect(json['roles'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(Role.count)
        check_pagination(json['pagination'])
        save_file('admin_api_roles_index', json)
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:role, name: 'zzz zzz zz zztest', locator: 'aa')
        FactoryBot.create(:role, name: 'TESTZZ ZZ ZZZ ZZZ', locator: 'ab')
        FactoryBot.create(:role, name: 'www test wwww test', locator: 'ac')
        FactoryBot.create(:role, name: 'aa aaaa aaaaaaa', locator: 'ad')
        expect(Role.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_roles_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['roles'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
