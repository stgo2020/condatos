class CreateRubidevices < ActiveRecord::Migration
  def change
    create_table :rubidevices do |t|
      t.references :user, index: true
      t.string :identifier
      t.integer :model
      t.date :creation
      t.string :owner

      t.timestamps null: false
    end
    add_foreign_key :rubidevices, :users
  end
end
