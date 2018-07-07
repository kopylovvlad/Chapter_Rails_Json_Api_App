class AddStateToChapter < ActiveRecord::Migration[5.1]
  def change
    add_column :chapters, :state, :string
  end
end
