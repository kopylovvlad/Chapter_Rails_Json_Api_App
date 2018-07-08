# frozen_string_literal: true
# == Schema Information
#
# Table name: comments
#
#  id         :bigint(8)        not null, primary key
#  body       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  chapter_id :integer
#
# Indexes
#
#  index_comments_on_chapter_id  (chapter_id)
#  index_comments_on_user_id     (user_id)
#

class Chapter::Comment < ApplicationRecord
  self.table_name = 'comments'

  scope :only_system, -> { where(user: nil) }
  scope :not_system, -> { where.not(user: nil) }

  belongs_to :user, optional: true
  belongs_to :chapter

  has_many :likes, dependent: :destroy

  validates :body, :chapter, presence: true

  def system?
    user.nil
  end
end
