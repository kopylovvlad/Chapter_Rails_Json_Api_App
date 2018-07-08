# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint(8)        not null, primary key
#  email              :string           not null
#  login              :string           not null
#  encrypted_password :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class User < ApplicationRecord
  has_many :chapters, dependent: :destroy
  has_many :comments, dependent: :destroy, class_name: 'Chapter::Comment'
  has_many :likes, dependent: :destroy, class_name: 'Chapter::Comment::Like'

  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :login, presence: true, uniqueness: { case_sensitive: true }
end
