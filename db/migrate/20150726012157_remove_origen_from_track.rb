class RemoveOrigenFromTrack < ActiveRecord::Migration
  def change
    remove_column :tracks, :origen, :float
  end
end
