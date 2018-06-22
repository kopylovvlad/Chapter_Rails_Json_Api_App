require 'rails_helper'

RSpec.describe 'Admin::Api::MaritalStatuses#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_marital_statuses_path
  include_examples 'applicant can not :get', :admin_api_marital_statuses_path
  include_examples 'director can not :get', :admin_api_marital_statuses_path
  include_examples 'certificates can not :get', :admin_api_marital_statuses_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:marital_status, 6)
        expect(MaritalStatus.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_marital_statuses_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['marital_statuses'].size).to eq(3)
        expect(json['marital_statuses'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(MaritalStatus.count)
        check_pagination(json['pagination'])
        save_file('admin_api_marital_statuses_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(MaritalStatus.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_marital_statuses_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['marital_statuses'].size).to eq(0)
        expect(json['total_count']).to eq(MaritalStatus.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:marital_status, name: 'zzz zzz zz zztest')
        FactoryBot.create(:marital_status, name: 'TESTZZ ZZ ZZZ ZZZ')
        FactoryBot.create(:marital_status, name: 'www test wwww test')
        FactoryBot.create(:marital_status, name: 'aa aaaa aaaaaaa')
        expect(MaritalStatus.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_marital_statuses_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['marital_statuses'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
