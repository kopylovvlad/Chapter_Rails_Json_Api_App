class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :body, null: false
      t.timestamps
    end

    add_reference :comments, :user, foreign_key: true
    add_reference :comments, :chapter, foreign_key: true
  end
end
