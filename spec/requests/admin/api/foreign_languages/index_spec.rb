require 'rails_helper'

RSpec.describe 'Admin::Api::foreign_languagess#index', type: :request do
  # checking roles
  include_examples 'guest can not :get', :admin_api_foreign_languages_path
  include_examples 'applicant can not :get', :admin_api_foreign_languages_path
  include_examples 'director can not :get', :admin_api_foreign_languages_path
  include_examples 'certificates can not :get', :admin_api_foreign_languages_path

  describe 'admin' do
    describe 'index with pagination' do
      it 'should return 3 items' do
        # prepare
        FactoryBot.create_list(:foreign_language, 6)
        expect(ForeignLanguage.count).to eq(6)
        sign_in(admin_user)

        # action
        get(
          admin_api_foreign_languages_path,
          headers: json_header,
          params: {
            pagination: { page: 1, per_page: 3 }
          }
        )

        # check
        success_response(response)
        expect(json['foreign_languages'].size).to eq(3)
        expect(json['foreign_languages'][0]['id']).to_not eq(nil)
        expect(json['total_count']).to eq(ForeignLanguage.count)
        check_pagination(json['pagination'])
        save_file('admin_api_foreign_languages_index', json)
      end

      it 'should return empty array' do
        # prepare
        expect(ForeignLanguage.count).to eq(0)
        sign_in(admin_user)

        # action
        get(
          admin_api_foreign_languages_path,
          headers: json_header,
        )

        # check
        success_response(response)
        expect(json['foreign_languages'].size).to eq(0)
        expect(json['total_count']).to eq(ForeignLanguage.count)
        check_empty_pagination(json['pagination'])
      end
    end

    describe 'searching' do
      it 'should search by title' do
        # prepare
        FactoryBot.create(:foreign_language, name: 'zzz zzz zz zztest')
        FactoryBot.create(:foreign_language, name: 'TESTZZ ZZ ZZZ ZZZ')
        FactoryBot.create(:foreign_language, name: 'www test wwww test')
        FactoryBot.create(:foreign_language, name: 'aa aaaa aaaaaaa')
        expect(ForeignLanguage.all.count).to eq(4)
        sign_in(admin_user)

        # action
        get(
          admin_api_foreign_languages_path,
          headers: json_header,
          params: { query: { title: 'test' } }
        )

        # check
        success_response(response)
        expect(json['foreign_languages'].size).to eq(3)
        expect(json['total_count']).to eq(3)
        check_pagination(json['pagination'])
      end
    end
  end
end
