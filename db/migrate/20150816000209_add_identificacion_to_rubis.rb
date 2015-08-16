class AddIdentificacionToRubis < ActiveRecord::Migration
  def change
    add_column :rubis, :identificacion, :string
  end
end
