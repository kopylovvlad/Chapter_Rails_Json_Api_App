# frozen_string_literal: true

class ChapterCommentMutator
  def self.create_system_comment(chapter)
    Chapter::Comment.create(
      chapter: chapter,
      body: 'Author updated the chapter',
      user_id: nil
    )
  end
end
