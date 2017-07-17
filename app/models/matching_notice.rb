class MatchingNotice < ActiveRecord::Base
    
    belongs_to :user_keyword
    belongs_to :notice_keyword
    
end
