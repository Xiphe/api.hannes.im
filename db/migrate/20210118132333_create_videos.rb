class CreateVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :thumbnail
      t.text :description
      t.string :url
      t.string :foreign_id
      t.string :platform
      t.datetime :published_at

      t.timestamps
    end
  end
end
