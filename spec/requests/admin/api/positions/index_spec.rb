require 'rails_helper'

RSpec.describe 'Admin::Api::Positions#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_positions_path
  include_examples 'applicant can not :get', :admin_api_positions_path
  include_examples 'director can not :get', :admin_api_positions_path
  include_examples 'certificates can not :get', :admin_api_positions_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:position, 6)
        expect(Position.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_positions_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['positions'].size).to eq(3)
        expect(json['positions'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(Position.count)
        check_pagination(json['pagination'])
        save_file('admin_api_positions_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(Position.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_positions_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['positions'].size).to eq(0)
        expect(json['total_count']).to eq(Position.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:position, name: 'zzz zzz zz zztest')
        FactoryBot.create(:position, name: 'TESTZZ ZZ ZZZ ZZZ')
        FactoryBot.create(:position, full_name: 'www test wwww test')
        FactoryBot.create(:position, full_name: 'aa aaaa aaaaaaa')
        expect(Position.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_positions_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['positions'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
