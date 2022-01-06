class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :name
      t.string :string
      t.string :rating
      t.integer :run_time

      t.timestamps
    end
  end
end
