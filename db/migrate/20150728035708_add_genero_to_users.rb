class AddGeneroToUsers < ActiveRecord::Migration
  def change
    add_column :users, :genero, :boolean
  end
end
