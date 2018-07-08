class ChapterMutator
  def self.update(item)
    ActiveRecord::Base.transaction do
      item.save!
      ::ChapterCommentMutator.create_system_comment(item)
    end
    item
  end

  def self.reviewing(item)
    ActiveRecord::Base.transaction do
      item.reviewing
      ::ChapterCommentMutator.create_system_comment(item)
    end
    item
  end

  def self.publishing(item)
    ActiveRecord::Base.transaction do
      item.publishing
      ::ChapterCommentMutator.create_system_comment(item)
    end
    item
  end
end
