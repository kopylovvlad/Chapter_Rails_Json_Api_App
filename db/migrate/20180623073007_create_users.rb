class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, uniq: true
      t.string :login, null: false, uniq: true
      t.string :encrypted_password, null: false
      t.timestamps
    end
  end
end
