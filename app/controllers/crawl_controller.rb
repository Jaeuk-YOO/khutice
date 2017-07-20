class CrawlController < ApplicationController

    def crawl_first
        
        # 카테고리 넘버와 페이지번호를 받습니다.
        # 이후 td.subject2 > a 로 접근해서 title과 link, category를 받습니다.
        
        require 'open-uri'
         
        ["1","2","3"].each do |target_url_pagination_num|
        ["1","2","3","4","5","8"].each do |target_url_category_num|

            target_url = "http://www.khu.ac.kr/life/noticeList.do?currentPage="+target_url_pagination_num+"&category=ntcate0"+target_url_category_num
            parsed = Nokogiri::HTML(open(target_url))
            
            parsed.css('td.subject2 > a').each do |parsed_css|
                parsed_db = Noticetitle.new
                parsed_db.title = parsed_css.text
                parsed_db.link = parsed_css["href"].delete "javascript:viewNotice('');"
                parsed_db.category = target_url_category_num
                parsed_db.save
            end
            
        end
        end
        redirect_to "/khutice/crawl_second"
        # noticeview => "http://www.khu.ac.kr/life/noticeView.do?noticeId=8976&category=ntcate01"
    end
    
    def crawl_second
        
        # img를 추가해줍니다.
        # contents와 upload_date를 추가해줍니다.
        
        require 'open-uri'
        
        notice_all = Noticetitle.all
        
        notice_all.each do |each_notice|
            target_url = "http://www.khu.ac.kr/life/noticeView.do?noticeId="+each_notice.link+"&category=ntcate0"+each_notice.category.to_s
            parsed = Nokogiri::HTML(open(target_url))
            parsed_db = Noticetitle.where("link" => each_notice.link).take
            
            parsed_css_img_arr = Array.new
            parsed.css("tr.contents > td // img").each do |parsed_css_img|
                if parsed_css_img["src"].include? "http"
                    parsed_css_img_arr.push(parsed_css_img["src"])
                else  
                    parsed_css_img_arr.push("http://www.khu.ac.kr"+parsed_css_img["src"])
                end
                
            end
            parsed_db.img = parsed_css_img_arr
            parsed_db.contents = parsed.css("tr.contents > td").text.delete "\r\n"
            
            parsed_db.upload_date = parsed.css("td")[2].text
            parsed_db.save
        end
        
        redirect_to "/khutice/crawl_third"
    end
    
    def crawl_third
        
        #keyword_pool에 noticekeyword를 입력합니다.
        
        notice_all = Noticetitle.all
        notice_all.each do |each_notice|
            
            keywordpool_all = KeywordPool.all
            keywordpool_all.each do |each_keyword_in_pool|
                if  (each_notice.contents.include? each_keyword_in_pool.name) || (each_notice.title.include? each_keyword_in_pool.name) == true
                    if  NoticeKeyword.where(:noticetitle_id => each_notice.id ).take.nil? == true
                    notice_keyword_input = NoticeKeyword.new
                    notice_keyword_input.noticetitle_id = each_notice.id
                    notice_keyword_input.name = each_keyword_in_pool.name
                    notice_keyword_input.status = true
                    notice_keyword_input.save
                    end
                else
                end
            end
        end
        redirect_to "/khutice/index"
    end
    
    def crawl_update
        require 'open-uri'

        ["1"].each do |target_url_pagination|
        ["1","2","3","4","5","8"].each do |target_url_category|

            target_url = "http://www.khu.ac.kr/life/noticeList.do?currentPage="+target_url_pagination+"&category=ntcate0"+target_url_category
            parsed = Nokogiri::HTML(open(target_url))
            
            parsed.css('td.subject2 > a').each do |parsed_css|
                if  Noticetitle.where(:title => parsed_css.text).take.nil?
                    parsed_db = Noticetitle.new
                    parsed_db.title = parsed_css.text
                    parsed_db.link = parsed_css["href"].delete "javascript:viewNotice('');"
                    parsed_db.category = target_url_category
                    parsed_db.save
                end
            end
            ## 이 코드가 안돈다... // 헤헤 됐당 06.21.15:59
        end
        end
        
        notice_all = Noticetitle.all
        
        notice_all.each do |each_notice|
            target_url = "http://www.khu.ac.kr/life/noticeView.do?noticeId="+each_notice.link+"&category=ntcate0"+each_notice.category.to_s
            parsed = Nokogiri::HTML(open(target_url))
            parsed_db = Noticetitle.where(:title => each_notice.title).take
            
            if parsed_db.img.nil?
                parsed_css_img_arr = Array.new
                parsed.css("tr.contents > td // img").each do |parsed_css_img|
                    if parsed_css_img["src"].include? "http"
                        parsed_css_img_arr.push(parsed_css_img["src"])
                    else  
                        parsed_css_img_arr.push("http://www.khu.ac.kr"+parsed_css_img["src"])
                    end
                    
                end
                    parsed_db.img = parsed_css_img_arr
                    parsed_db.contents = parsed.css("tr.contents > td").text.delete "\r\n"
                    
                    parsed_db.upload_date = parsed.css("td")[2].text
                    parsed_db.save
            end
        end
        
        notice_all_two = Noticetitle.all
        notice_all_two.each do |each_notice|
            if NoticeKeyword.where(:noticetitle_id => each_notice.id).take.nil?
                keywordpool_all = KeywordPool.all
                keywordpool_all.each do |each_keyword_in_pool|
                    if  ((each_notice.contents.include? each_keyword_in_pool.name)  || (each_notice.title.include? each_keyword_in_pool.name))
                        notice_keyword_input = NoticeKeyword.new
                        notice_keyword_input.noticetitle_id = each_notice.id
                        notice_keyword_input.name = each_keyword_in_pool.name
                        notice_keyword_input.status = true
                        notice_keyword_input.save
                    else
                    end
                end
            end
        end        
        
        redirect_to "/khutice/standard_keyword_plus"
    end

end
