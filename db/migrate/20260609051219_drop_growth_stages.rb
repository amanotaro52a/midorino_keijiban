class DropGrowthStages < ActiveRecord::Migration[7.2]
  def change
    drop_table :growth_stages
  end
end
