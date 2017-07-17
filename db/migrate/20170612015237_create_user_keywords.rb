class CreateUserKeywords < ActiveRecord::Migration
  def change
    create_table :user_keywords do |t|

      t.string :name
      t.integer :user_id
      t.string :link
      t.boolean :status
      
      t.timestamps null: false
    end
  end
end
