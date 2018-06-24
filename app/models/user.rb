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

class User < ApplicationRecord
  has_many :chapters
  has_many :comments
  has_many :likes

  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :login, presence: true, uniqueness: { case_sensitive: true }
end
