class CreateUserMailStatuses < ActiveRecord::Migration
  def change
    create_table :user_mail_statuses do |t|
      
      t.boolean :status
      t.string :user_name
      t.string :users_id
      t.string :keyword_name
      t.string :user_keywords_id
      t.string :link
      t.string :noticetitles_id

      t.timestamps null: false
    end
  end
end
