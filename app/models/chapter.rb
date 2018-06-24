# frozen_string_literal: true

# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_chapters_on_user_id  (user_id)
#

class Chapter < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :user, presence: true
end
