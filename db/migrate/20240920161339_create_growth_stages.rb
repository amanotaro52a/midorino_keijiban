class CreateGrowthStages < ActiveRecord::Migration[7.2]
  def change
    create_table :growth_stages do |t|
      t.references :diary, null: false, foreign_key: true
      t.string :stage_name
      t.text :description
      t.string :image
      t.text :growth_stage_contents
    end
  end
end
