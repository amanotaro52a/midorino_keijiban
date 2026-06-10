class RenameDiariesToPosts < ActiveRecord::Migration[7.2]
  def change
    rename_table :diaries, :posts
  end
end
