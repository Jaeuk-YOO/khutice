class SendingController < ApplicationController

  def email_send
    
    
    all_user = User.all
    all_user.each do |each_user|   
      each_user.user_keywords.each do |each_user_each_keyword|
        unless each_user_each_keyword.link.nil?
          each_user_each_keyword.notice_keywords.each do |each_user_each_keyword_notice_keyword|
            unless UserMailStatus.where(user_name: each_user.user_name, link: each_user_each_keyword_notice_keyword.link).nil?
            
              nt_id = each_user_each_keyword_notice_keyword.noticetitle_id
              ulink = Noticetitle.where(:id => nt_id).take.link
              utitle = Noticetitle.where(:id => nt_id).take.title
              ucategory =  Noticetitle.where(:id => nt_id).take.category
              
                    
              #each_user에게 메일을 보내는 process
              
              title = "khutice가 새로운 공지정보를 알려드립니다."
              user_id = each_user.id
              contents = "#{utitle}" + "\n너가 선택한 키워드에 대해 공지사항이 등록되었어! 확인해볼래?" + "http://khutice2017-cloned-jaeuk-yoo.c9users.io"
              content = "<div style='width:640px; margin-top:50px; margin-left:100px;'><h2>선택한 키워드에 대한 공지사항이 등록되었어요!</h2></div>"
              #content = "#{utitle}" + "\n너가 선택한 키워드 관련해서 글이 떴어" + " 바로갈래? : " + "http://www.khu.ac.kr/life/noticeView.do?noticeId=" + "#{ulink}" + "&category=ntcate0"+"#{ucategory}"  
              Usermailer.notice(title, content, user_id).deliver_now
           
            end
            
            if UserMailStatus.where(user_name: each_user.user_name, link: each_user_each_keyword_notice_keyword.link).nil?
            
              ues = UserMailStatus.new
              ues.status = true
              ues.user_name = each_user.user_name
              ues.user_id = each_user.id
              ues.keyword_name = hidden_name
              ues.user_keyword_id = each_user_each_keyword.id
              ues.link = each_user_each_keyword_notice_keyword.link
              ues.noticetitle_id = each_user_each_keyword_notice_keyword.id
              ues.save
            
            end
             
          end
        end
      end

    end
    
    redirect_to '/'
  end

  def mailer_recall
    
    arr_user_id=Array.new
    arr_href_link=Array.new
    arr_utitle=Array.new
        
        all_user = User.all
        all_user.each do |each_user|
          arr_user_id.push(each_user.id) # array로 넘기기 1. each_user.id는 한번만 쓰기 위해... 앞에서 push
          each_user.user_keywords.each do |each_user_each_keyword|
            unless each_user_each_keyword.link.nil? #유저가 선택한 유저키워드의 링크 숫자 값 체크
              each_user_each_keyword.notice_keywords.each do |each_user_each_keyword_notice_keyword|
                if UserMailStatus.where(user_name: each_user.user_name, link: each_user_each_keyword_notice_keyword.noticetitle.link).empty?
                
                  nt_id = each_user_each_keyword_notice_keyword.noticetitle_id
                  ulink = Noticetitle.where(:id => nt_id).take.link
                  utitle = Noticetitle.where(:id => nt_id).take.title
                  ucategory =  Noticetitle.where(:id => nt_id).take.category
                  
                  
                  arr_utitle.push(Noticetitle.where(:id => nt_id).take.title)
                  arr_href_link.push("http://www.khu.ac.kr/life/noticeView.do?noticeId="+ulink.to_s+"&category=ntcate0"+ucategory.to_s)           
                end
                
                #mail status남기기
                if UserMailStatus.where(user_name: each_user.user_name, link: each_user_each_keyword_notice_keyword.noticetitle.link).empty?
                  ues = UserMailStatus.new
                  ues.status = true #sending과정을 거침.
                  ues.user_name = each_user.user_name
                  ues.users_id = each_user.id
                  ues.user_keywords_id = each_user_each_keyword.id
                  ues.link = each_user_each_keyword_notice_keyword.noticetitle.link
                  ues.noticetitles_id = each_user_each_keyword_notice_keyword.id
                  ues.save
                end
                
              end
            end
          end
    
            #each_user에게 메일을 보내는 process
                      
            title = "khutice가 새로운 공지정보를 알려드립니다."
            user_id = arr_user_id[0]
            #content = "#{utitle}" + "너가 선택한 키워드에 대해 공지사항이 등록되었어! 확인해볼래?" + "http://khutice2017-cloned-jaeuk-yoo.c9users.io"
            content = arr_utitle.zip(arr_href_link)
            #content = "#{utitle}" + "\n너가 선택한 키워드 관련해서 글이 떴어" + " 바로갈래? : " + "http://www.khu.ac.kr/life/noticeView.do?noticeId=" + "#{ulink}" + "&category=ntcate0"+"#{ucategory}"  
            if content == []
              puts "보낼게 없다!"
            elsif content != []
              Usermailer.notice(title, content, user_id).deliver_now
            end
            arr_user_id.clear
            arr_href_link.clear
            arr_utitle.clear
    end
    redirect_to '/'
  end

end

        
    
    