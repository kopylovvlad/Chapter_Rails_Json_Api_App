# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string           not null
#  login              :string           not null
#  encrypted_password :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:login) }
  # it { should validate_presence_of(:encrypted_password) }

  describe 'email should be uniq' do
    it 'works' do
      expect(User.count).to eq(0)
      u1 = FactoryBot.build(
        :user,
        email: 'user1email@tmail.com',
        encrypted_password: PasswordEncryptor.call('super_pass')
      )
      expect(u1.valid?).to eq(true)
      expect(u1.save).to eq(true)

      u2 = FactoryBot.build(
        :user,
        email: 'user1email@tmail.com',
        encrypted_password: PasswordEncryptor.call('super_pass12')
      )
      expect(u2.valid?).to eq(false)
      expect(u2.save).to eq(false)
      expect(User.count).to eq(1)
    end
  end
end
