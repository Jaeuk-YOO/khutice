# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

["장학","아르바이트","근로","채용","해외","공모","대회","봉사","인턴","연수","교환","유학","전과","다전공","특강","리쿠르팅","계절"].each do |each_keyword_in_pool|
    KeywordPool.create(name: each_keyword_in_pool, user_input_count: "9999")
end
