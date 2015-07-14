class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :latitud
      t.float :longitud
      t.time :tiempo
      t.references :track, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
