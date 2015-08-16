class AddRubiToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rubi, :string
  end
end
