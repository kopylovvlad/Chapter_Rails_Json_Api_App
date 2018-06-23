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
  it { should validate_presence_of(:encrypted_password) }

  # it { should validate_uniqueness_of(:email) }
  # it { should validate_uniqueness_of(:login) }
end
