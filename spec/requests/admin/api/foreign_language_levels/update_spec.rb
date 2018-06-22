require 'rails_helper'

RSpec.describe 'Admin::Api::ForeignLanguageLevels#update', type: :request do
  # checking roles
  include_examples(
    'guest can not :patch',
    :admin_api_foreign_language_level_path,
    FactoryBot.create(:foreign_language_level).id
  )
  include_examples(
    'applicant can not :patch',
    :admin_api_foreign_language_level_path,
    FactoryBot.create(:foreign_language_level).id
  )
  include_examples(
    'director can not :patch',
    :admin_api_foreign_language_level_path,
    FactoryBot.create(:foreign_language_level).id
  )
  include_examples(
    'certificates can not :patch',
    :admin_api_foreign_language_level_path,
    FactoryBot.create(:foreign_language_level).id
  )

  let(:item) do
    FactoryBot.create(
      :foreign_language_level,
      name: 'lololo',
      active: false,
      priority: 9
    )
  end

  describe 'admin' do
    describe 'success' do
      it 'should update item' do
        # prepare
        item
        expect(ForeignLanguageLevel.all.count).to eq(1)
        sign_in(admin_user)
        new_title = Faker::Lorem.words(5).join(' ')

        # action
        patch(
          admin_api_foreign_language_level_path(item),
          headers: json_header,
          params: {
            foreign_language_levels:
              {
                name: new_title,
                priority: 3,
                active: true
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to eq(item.id)
        expect(json['name']).to eq(new_title)
        expect(json['priority']).to eq(3)
        expect(json['active']).to eq(true)
        expect(ForeignLanguageLevel.all.count).to eq(1)
        save_file('admin_api_foreign_language_levels_update_success', json)
      end
    end

    describe 'invalid item' do
      it 'should return array with validation errors' do
        # prepare
        item
        expect(ForeignLanguageLevel.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_foreign_language_level_path(item),
          headers: json_header,
          params: {
            foreign_language_levels:
              {
                name: '',
              }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(ForeignLanguageLevel.all.count).to eq(1)
        save_file('admin_api_foreign_language_levels_update_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        item
        expect(ForeignLanguageLevel.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_foreign_language_level_path(item),
          headers: json_header,
          params: {
            foreign_language_levels: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(ForeignLanguageLevel.all.count).to eq(1)
      end
    end

    describe 'does not exist' do
      it 'should return 404' do
        # prepare
        expect(ForeignLanguageLevel.all.count).to eq(0)

        sign_in(admin_user)

        # action
        patch(
          admin_api_foreign_language_level_path(999),
          headers: json_header,
          params: {
            foreign_language_levels: { title: '123' }
          }
        )

        # check
        not_found_response(response)
        expect(ForeignLanguageLevel.all.count).to eq(0)
      end
    end
  end
end
