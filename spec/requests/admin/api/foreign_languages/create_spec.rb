require 'rails_helper'

RSpec.describe 'Admin::Api::foreign_languages#create', type: :request do
  # checking roles
  include_examples 'guest can not :post', :admin_api_foreign_languages_path
  include_examples 'applicant can not :post', :admin_api_foreign_languages_path
  include_examples 'director can not :post', :admin_api_foreign_languages_path
  include_examples 'certificates can not :post', :admin_api_foreign_languages_path

  describe 'admin' do
    describe 'success' do
      it 'should create item' do
        # prepare
        count = ForeignLanguage.all.count
        sign_in(admin_user)
        param_title = Faker::Lorem.words(4).join(' ')
        params_prior = rand(100)

        # action
        post(
          admin_api_foreign_languages_path,
          headers: json_header,
          params: {
            foreign_languages:
              {
                name: param_title,
                priority: params_prior,
                active: false
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to_not eq(nil)
        expect(json['name']).to eq(param_title)
        expect(json['priority']).to eq(params_prior)
        expect(json['active']).to eq(false)
        expect(ForeignLanguage.all.count).to eq(count + 1)
        save_file('admin_api_foreign_languages_create_success', json)
      end
    end

    describe 'invalid data' do
      it 'should return array with validation errors' do
        # prepare
        count = ForeignLanguage.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_foreign_languages_path,
          headers: json_header,
          params: {
            foreign_languages: { active: true }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(ForeignLanguage.all.count).to eq(count)
        save_file('admin_api_foreign_languages_create_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        count = ForeignLanguage.all.count
        sign_in(admin_user)

        # action
        post(
          admin_api_foreign_languages_path,
          headers: json_header,
          params: {
            foreign_languages: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(ForeignLanguage.all.count).to eq(count)
      end
    end
  end
end
