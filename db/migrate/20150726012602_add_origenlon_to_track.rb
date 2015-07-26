class AddOrigenlonToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :origenlon, :float
  end
end
