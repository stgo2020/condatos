class AddDestinolatToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :destinolat, :float
  end
end
