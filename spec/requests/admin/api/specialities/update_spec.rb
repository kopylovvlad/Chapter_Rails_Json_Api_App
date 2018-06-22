require 'rails_helper'

RSpec.describe 'Admin::Api::Specialities#update', type: :request do
  # checking roles
  include_examples(
    'guest can not :patch',
    :admin_api_speciality_path,
    FactoryBot.create(:speciality).id
  )
  include_examples(
    'applicant can not :patch',
    :admin_api_speciality_path,
    FactoryBot.create(:speciality).id
  )
  include_examples(
    'director can not :patch',
    :admin_api_speciality_path,
    FactoryBot.create(:speciality).id
  )
  include_examples(
    'certificates can not :patch',
    :admin_api_speciality_path,
    FactoryBot.create(:speciality).id
  )

  let(:item) do
    FactoryBot.create(
      :speciality,
      name: 'lololo',
      genitive_name: 'azaza',
      active: false,
      priority: 9
    )
  end

  describe 'admin' do
    describe 'success' do
      it 'should update item' do
        # prepare
        item
        expect(item.position_id).to_not eq(nil)
        expect(Speciality.all.count).to eq(1)
        sign_in(admin_user)
        new_title = Faker::Lorem.words(5).join(' ')
        new_title2 = Faker::Lorem.words(3).join(' ')
        new_position_id = FactoryBot.create(:position).id
        expect(item.position_id).to_not eq(new_position_id)

        # action
        patch(
          admin_api_speciality_path(item),
          headers: json_header,
          params: {
            specialities:
              {
                name: new_title,
                genitive_name: new_title2,
                position_id: new_position_id,
                priority: 3,
                active: true
              }
          }
        )

        # check
        success_response(response)
        expect(json['id']).to eq(item.id)
        expect(json['name']).to eq(new_title)
        expect(json['genitive_name']).to eq(new_title2)
        expect(json['position_id']).to eq(new_position_id)
        expect(json['priority']).to eq(3)
        expect(json['active']).to eq(true)
        expect(Speciality.all.count).to eq(1)
        save_file('admin_api_specialities_update_success', json)
      end
    end

    describe 'invalid item' do
      it 'should return array with validation errors' do
        # prepare
        item
        expect(Speciality.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_speciality_path(item),
          headers: json_header,
          params: {
            specialities:
              {
                name: '',
              }
          }
        )

        # check
        error_response(response)
        expect(json['errors'].present?).to eq(true)
        expect(json['errors'].size).to be > 0
        expect(Speciality.all.count).to eq(1)
        save_file('admin_api_specialities_update_fail', json)
      end
    end

    describe 'params require' do
      it 'should return incorrect_data' do
        # prepare
        item
        expect(Speciality.all.count).to eq(1)
        sign_in(admin_user)

        # action
        patch(
          admin_api_speciality_path(item),
          headers: json_header,
          params: {
            specialitys: {}
          }
        )

        # check
        error_response(response)
        error_json
        expect(Speciality.all.count).to eq(1)
      end
    end

    describe 'does not exist' do
      it 'should return 404' do
        # prepare
        expect(Speciality.all.count).to eq(0)

        sign_in(admin_user)

        # action
        patch(
          admin_api_speciality_path(999),
          headers: json_header,
          params: {
            specialities: { name: '123' }
          }
        )

        # check
        not_found_response(response)
        expect(Speciality.all.count).to eq(0)
      end
    end
  end
end
