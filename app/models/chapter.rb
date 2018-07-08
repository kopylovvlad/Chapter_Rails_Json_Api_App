# frozen_string_literal: true
# == Schema Information
#
# Table name: chapters
#
#  id         :bigint(8)        not null, primary key
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
  scope :not_draft, ->{ where.not(state: 'draft') }
  belongs_to :user

  has_many :comments, dependent: :destroy, class_name: 'Chapter::Comment'

  validates :title, presence: true
  validates :user, presence: true

  # state-machine
  # draft, on_review, approved, published
  state_machine :state, attribute: :state, initial: :draft do
    event :reviewing do
      transition :draft => :on_review
    end
    event :approving do
      transition :on_review => :approved
    end
    event :publishing do
      transition :approved => :published
    end

    # state :first_gear, :second_gear do
    #  validates_presence_of :seatbelt_on
    # end
  end
end
