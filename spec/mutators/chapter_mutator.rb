require 'rails_helper'

RSpec.describe ChapterMutator, type: :model do
  it 'should create an user' do
    # prepare
    expect(Chapter.count).to eq(0)
    input_params = {
      title: 'sdfadasd',
      body: 'sdfsdfdsfasdasd',
      user_id: FactoryBot.create(:user).id
    }

    # action
    item = ChapterMutator.create(input_params)

    # check
    expect(item.valid?).to eq(true)
    expect(item.errors.present?).to eq(false)
    expect(Chapter.count).to eq(1)
  end

  it 'should return item with errors' do
    # prepare
    expect(Chapter.count).to eq(0)
    input_params = {
      title: '',
      body: 'sdfsdfdsfasdasd',
      user_id: nil
    }

    # action
    item = ChapterMutator.create(input_params)

    # check
    expect(item.valid?).to eq(false)
    expect(item.errors.size).to be > 0
    expect(Chapter.count).to eq(0)
  end
end
