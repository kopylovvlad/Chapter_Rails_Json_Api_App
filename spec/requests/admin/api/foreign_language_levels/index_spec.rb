require 'rails_helper'

RSpec.describe 'Admin::Api::foreign_language_levelss#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_foreign_language_levels_path
  include_examples 'applicant can not :get', :admin_api_foreign_language_levels_path
  include_examples 'director can not :get', :admin_api_foreign_language_levels_path
  include_examples 'certificates can not :get', :admin_api_foreign_language_levels_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:foreign_language_level, 6)
        expect(ForeignLanguageLevel.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_foreign_language_levels_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['foreign_language_levels'].size).to eq(3)
        expect(json['foreign_language_levels'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(ForeignLanguageLevel.count)
        check_pagination(json['pagination'])
        save_file('admin_api_foreign_language_levels_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(ForeignLanguageLevel.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_foreign_language_levels_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['foreign_language_levels'].size).to eq(0)
        expect(json['total_count']).to eq(ForeignLanguageLevel.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:foreign_language_level, name: 'zzz zzz zz zztest')
        FactoryBot.create(:foreign_language_level, name: 'TESTZZ ZZ ZZZ ZZZ')
        FactoryBot.create(:foreign_language_level, name: 'www test wwww test')
        FactoryBot.create(:foreign_language_level, name: 'aa aaaa aaaaaaa')
        expect(ForeignLanguageLevel.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_foreign_language_levels_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['foreign_language_levels'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
