class AddOrigenlatToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :origenlat, :float
  end
end
