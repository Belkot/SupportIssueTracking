class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.integer :ticket_id
      t.integer :user_id

      t.timestamps
    end
    add_index :owners, :ticket_id
    add_index :owners, :user_id
  end
end
