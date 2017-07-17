class CreateNoticeKeywords < ActiveRecord::Migration
  def change
    create_table :notice_keywords do |t|

      t.string :name
      t.boolean :status
      t.integer :noticetitle_id

      t.timestamps null: false
    end
  end
end
