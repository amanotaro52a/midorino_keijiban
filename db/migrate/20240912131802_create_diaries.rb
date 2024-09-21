class CreateDiaries < ActiveRecord::Migration[7.2]
  def change
    create_table :diaries do |t|
      t.string :title, null: false
      t.text :summary_content, null: false
      t.string :thumbnail_image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
