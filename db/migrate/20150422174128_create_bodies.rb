class CreateBodies < ActiveRecord::Migration
  def change
    create_table :bodies do |t|
      t.integer :ticket_id, null: false
      t.text :body
      t.integer :user_id, null: true

      t.timestamps
    end
    add_index :bodies, :ticket_id
    add_index :bodies, :user_id
  end
end
