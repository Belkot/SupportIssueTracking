class AddEnableToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :enable, :boolean, default: true
  end
end
