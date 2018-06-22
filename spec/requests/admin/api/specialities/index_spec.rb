require 'rails_helper'

RSpec.describe 'Admin::Api::specialitiess#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_specialities_path
  include_examples 'applicant can not :get', :admin_api_specialities_path
  include_examples 'director can not :get', :admin_api_specialities_path
  include_examples 'certificates can not :get', :admin_api_specialities_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:speciality, 6)
        expect(Speciality.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_specialities_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['specialities'].size).to eq(3)
        expect(json['specialities'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(Speciality.count)
        check_pagination(json['pagination'])
        save_file('admin_api_specialities_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(Speciality.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_specialities_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['specialities'].size).to eq(0)
        expect(json['total_count']).to eq(Speciality.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:speciality, name: 'zzz zzz zz zztest', genitive_name: 'aa')
        FactoryBot.create(:speciality, name: 'TESTZZ ZZ ZZZ ZZZ', genitive_name: 'aa')
        FactoryBot.create(:speciality, name: 'www test wwww test', genitive_name: 'aa')
        FactoryBot.create(:speciality, name: 'aa aaaa aaaaaaa', genitive_name: 'aa')
        expect(Speciality.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_specialities_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['specialities'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
