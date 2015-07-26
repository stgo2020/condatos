class AddOrigenToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :origen, :float
  end
end
