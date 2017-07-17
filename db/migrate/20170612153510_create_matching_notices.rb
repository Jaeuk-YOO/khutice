class CreateMatchingNotices < ActiveRecord::Migration
  def change
    create_join_table :user_keywords, :notice_keywords do |t|
      
      t.index([:user_keyword_id, :notice_keyword_id], name: 'user_notice_keyword_join')
      t.index([:notice_keyword_id, :user_keyword_id], name: 'user_keyword_notice_join')

      #t.string :title
      #t.string :link
      #t.integer :user_keyword_id
      #t.integer :notice_keyword_id

      t.timestamps null: false
    end
  end
end
