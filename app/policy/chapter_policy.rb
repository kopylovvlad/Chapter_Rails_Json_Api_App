# frozen_string_literal: true

class ChapterPolicy
  # Status can’t be changed to “approved” if less than 50% of paticipants commented on it.
  def self.able_to_approving?(chapter)
    return false unless chapter.on_review?

    users_count = User.count - 1
    author = chapter.user
    commented_users = chapter.comments.not_system
                             .pluck(:user_id)
                             .uniq
                             .reject { |i| i == author.id }
                             .size

    commented_users > 0 and commented_users > (users_count / 2)
  end
end
