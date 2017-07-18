class CreateUserTeaches < ActiveRecord::Migration
  def change
    create_table :user_teaches do |t|

      t.integer :user_id
      
      #유저정보
      t.string :email
      t.string :user_name
      t.string :major
      
      #공지정보
      t.string :notice_title
      t.string :notice_link
      t.string :notice_keyword
      t.string :notice_category
      
      #유저가 입력한 정보
      t.string :user_keyword_name
      
      #유저가 싫어하는 이유
      t.integer :user_dislike
      
      t.timestamps null: false
    end
  end
end
