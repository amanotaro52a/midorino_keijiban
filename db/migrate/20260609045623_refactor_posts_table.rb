class RefactorPostsTable < ActiveRecord::Migration[7.2]
  def change
    rename_column :posts, :summary_content, :body

    change_column_null :posts, :body, true

    remove_column :posts, :thumbnail_image, :string
    remove_column :posts, :variety_name, :string
    remove_column :posts, :cultivation_location, :string
    remove_column :posts, :cultivation_method, :string

    add_column :posts, :image, :string

    add_column :posts,
               :likes_count,
               :integer,
               default: 0,
               null: false
  end
end
