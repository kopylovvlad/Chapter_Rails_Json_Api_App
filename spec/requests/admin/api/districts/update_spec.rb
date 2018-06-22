require 'rails_helper'

RSpec.describe 'Admin::Api::Districts#update', type: :request do
  # checking roles
  include_examples(
    'guest can not :patch',
    :admin_api_district_path,
    FactoryBot.create(:district).id
  )
  include_examples(
    'applicant can not :patch',
    :admin_api_district_path,
    FactoryBot.create(:district).id
  )
  include_examples(
    'director can not :patch',
    :admin_api_district_path,
    FactoryBot.create(:district).id
  )
  include_examples(
    'certificates can not :patch',
    :admin_api_district_path,
    FactoryBot.create(:district).id
  )

  let(:item) do
    FactoryBot.create(
      :district,
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
        expect(item.division_id).to_not eq(nil)
        expect(District.all.count).to eq(1)
        sign_in(admin_user)
        new_title = Faker::Lorem.words(5).join(' ')
        new_division_id = FactoryBot.create(:division).id
        expect(item.division_id).to_not eq(new_division_id)

        # action
        patch(
          admin_api_district_path(item),
          headers: json_header,
          params: {
            districts:
              {
                name: new_title,
                division_id: new_division_id,
                priority: 3,
                active: true
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to eq(item.id)
        expect(json['name']).to eq(new_title)
        expect(json['division_id']).to eq(new_division_id)
        expect(json['priority']).to eq(3)
        expect(json['active']).to eq(true)
        expect(District.all.count).to eq(1)
        save_file('admin_api_districts_update_success', json)
      end
    end

    describe 'invalid item' do
      it 'should return array with validation errors' do
        # prepare
        item
        expect(District.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_district_path(item),
          headers: json_header,
          params: {
            districts:
              {
                name: '',
              }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(District.all.count).to eq(1)
        save_file('admin_api_districts_update_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        item
        expect(District.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_district_path(item),
          headers: json_header,
          params: {
            districts: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(District.all.count).to eq(1)
      end
    end

    describe 'does not exist' do
      it 'should return 404' do
        # prepare
        expect(District.all.count).to eq(0)

        sign_in(admin_user)

        # action
        patch(
          admin_api_district_path(999),
          headers: json_header,
          params: {
            districts: { name: '123' }
          }
        )

        # check
        not_found_response(response)
        expect(District.all.count).to eq(0)
      end
    end
  end
end
