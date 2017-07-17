class CreateStandardKeywords < ActiveRecord::Migration
  def change
    create_table :standard_keywords do |t|

      t.string :name

      t.timestamps null: false
    end
  end
end
