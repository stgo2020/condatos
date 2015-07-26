class AddDestinoToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :destino, :float
  end
end
