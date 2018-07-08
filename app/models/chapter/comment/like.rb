# frozen_string_literal: true
# == Schema Information
#
# Table name: likes
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  comment_id :integer
#
# Indexes
#
#  index_likes_on_comment_id  (comment_id)
#  index_likes_on_user_id     (user_id)
#

class Chapter::Comment::Like < ApplicationRecord
  self.table_name = 'likes'
  scope :preload_all, -> { preload(:comment, :user) }
  belongs_to :comment
  belongs_to :user

  validates :comment, presence: true
  validates :user, presence: true, uniqueness: { scope: :comment }
  validate :only_user_comment

  private

  def only_user_comment
    return unless comment.present?
    return if comment.user.present?
    errors.add(:comment, 'You can\'t like system comment')
  end
end
