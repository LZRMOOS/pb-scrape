class CreateListings < ActiveRecord::Migration[5.2]
  def change
    create_table :listings do |t|
      t.string :title
      t.string :url
      t.string :category
      t.string :price
      t.date :original_post_date
      t.date :last_repost_date
      t.string :sale_status
      t.integer :view_count
      t.integer :watch_count

      t.timestamps
    end
  end
end
