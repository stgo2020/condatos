class AddTiempoToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :tiempo, :integer
  end
end
