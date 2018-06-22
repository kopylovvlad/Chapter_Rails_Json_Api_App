require 'rails_helper'

RSpec.describe 'Admin::Api::divisionss#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_divisions_path
  include_examples 'applicant can not :get', :admin_api_divisions_path
  include_examples 'director can not :get', :admin_api_divisions_path
  include_examples 'certificates can not :get', :admin_api_divisions_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:division, 6)
        expect(Division.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_divisions_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['divisions'].size).to eq(3)
        expect(json['divisions'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(Division.count)
        check_pagination(json['pagination'])
        save_file('admin_api_divisions_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(Division.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_divisions_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['divisions'].size).to eq(0)
        expect(json['total_count']).to eq(Division.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:division, name: 'zzz zzz zz zztest', acronym: 'aaa')
        FactoryBot.create(:division, name: 'TESTZZ ZZ ZZZ ZZZ', acronym: 'aaa')
        FactoryBot.create(:division, name: 'www test wwww test', acronym: 'aaa')
        FactoryBot.create(:division, name: 'aa aaaa aaaaaaa', acronym: 'aaa')
        expect(Division.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_divisions_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['divisions'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
