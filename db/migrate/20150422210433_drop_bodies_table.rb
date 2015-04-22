class DropBodiesTable < ActiveRecord::Migration
  def up
    drop_table :bodies
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
