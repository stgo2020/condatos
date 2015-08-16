class CreateRubis < ActiveRecord::Migration
  def change
    create_table :rubis do |t|
      t.integer :user_id
      t.integer :serie
      t.text :nombre

      t.timestamps null: false
    end
  end
end
