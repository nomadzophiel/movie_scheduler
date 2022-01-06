class RemoveStringFromMovie < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :string, :string
  end
end
