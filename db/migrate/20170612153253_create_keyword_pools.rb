class CreateKeywordPools < ActiveRecord::Migration
  def change
    create_table :keyword_pools do |t|

      t.string :name
      t.integer :user_input_count

      t.timestamps null: false
    end
  end
end
