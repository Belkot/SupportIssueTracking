class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :status_type_id
      t.integer :user_id
      t.integer :ticket_id

      t.timestamps
    end
    add_index :statuses, :status_type_id
    add_index :statuses, :user_id
    add_index :statuses, :ticket_id
  end
end
