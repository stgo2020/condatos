class AddNombreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nombre, :string
  end
end
