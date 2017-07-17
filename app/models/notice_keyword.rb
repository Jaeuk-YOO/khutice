class NoticeKeyword < ActiveRecord::Base
    
    belongs_to :noticetitle
    has_and_belongs_to_many :user_keywords
end
