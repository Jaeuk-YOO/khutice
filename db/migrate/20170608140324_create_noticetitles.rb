class CreateNoticetitles < ActiveRecord::Migration
  def change
    create_table :noticetitles do |t|

      t.integer :category
      t.string :title
      t.string :link
      t.string :upload_date
      t.text :contents
      t.string :img
      
      t.timestamps null: false
    end
  end
end
