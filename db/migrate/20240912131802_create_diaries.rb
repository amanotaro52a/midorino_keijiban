class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.string :title, null: false
      t.text :summary_content, null: false
      t.string :thumbnail_image
      t.string :plant_name
      t.string :variety_name
      t.string :cultivation_location
      t.string :cultivation_method
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
