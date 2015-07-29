class AddNacimientoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nacimiento, :date
  end
end
