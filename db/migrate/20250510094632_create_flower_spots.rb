class CreateFlowerSpots < ActiveRecord::Migration[7.0]
  def change
    create_table :flower_spots do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.float :latitude
      t.float :longitude
      t.integer :peak_season_months, array: true, default: []
      t.integer :parking, default: 0, null: false
      t.integer :fee_type, default: 0, null: false
      t.text :fee_detail
      t.text :flower_type_details
      t.string :official_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :flower_spots, [:latitude, :longitude]
  end
end
