class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.timestamps
    end
    add_reference :likes, :user, foreign_key: true, index: true
    add_reference :likes, :comment, foreign_key: true, index: true
  end
end
