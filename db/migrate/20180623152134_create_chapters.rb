class CreateChapters < ActiveRecord::Migration[5.1]
  def change
    create_table :chapters do |t|
      t.string :title, null: false
      t.text :body
      t.timestamps
    end
    add_reference :chapters, :user, foreign_key: true
  end
end
