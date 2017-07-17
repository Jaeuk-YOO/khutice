class UserKeyword < ActiveRecord::Base

    validates :name, presence: true
    
    belongs_to :user
    has_and_belongs_to_many :notice_keywords

    
end
