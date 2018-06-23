module ChapterMutator
  def self.create(params)
    item = Chapter.new(params)
    return item unless item.valid?
    item.save and item
  end
end
