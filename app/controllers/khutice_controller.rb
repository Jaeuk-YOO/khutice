class KhuticeController < ApplicationController
    
    def index
        @notice_all = Noticetitle.all
    end
    
    
    def user_keyword_input_index
        #before_action :authenticate
        
    end
    
    def user_keyword_input_write
        #before_action :authenticate

        @keyword_by_current_user = current_user.user_keywords.all
        @standards = StandardKeyword.all
        @keyword_pool = KeywordPool.all

    end
    
    def user_keyword_input_create
        #before_action :authenticate
        #비면 돌아가게가 안먹...0717
        #redirect_to '/khutice/user_keyword_input_write' && return if ((params[:keyword] == "") && (params[:keyword_input] == "")) == true
        
        #체크박스 있는지 체크
        if ((params[:keyword]!=nil)&(params[:keyword_input] != ""))
            params[:keyword][:chkboxes].push(params[:keyword_input]).each do |keyword_input_all|
                #등록 절차 chkbox랑 같이 받을 때
                if current_user.user_keywords.where(:name => keyword_input_all).take.nil?
                    user_input_keyword = UserKeyword.new
                    user_input_keyword.name = keyword_input_all
                    user_input_keyword.user_id = current_user.id
                    user_input_keyword.status = false
                    user_input_keyword.save
                        
                    if KeywordPool.where(:name => keyword_input_all).take.nil?
                        user_input_keyword_inpool = KeywordPool.new
                        user_input_keyword_inpool.name = keyword_input_all
                        user_input_keyword_inpool.user_input_count = 1 
                        user_input_keyword_inpool.save
                    elsif KeywordPool.where(:name => keyword_input_all).take.user_input_count < 9999
                        user_input_keyword_inpool = KeywordPool.where(:name => keyword_input_all).take
                        user_input_keyword_inpool.user_input_count = user_input_keyword_inpool.user_input_count+1
                        user_input_keyword_inpool.save
                    end
                end   
            end
        elsif ((params[:keyword] == nil) && (params[:keyword_input] != ""))
        #등록 절차 chkbox 없이 input만 받을 때 
            if current_user.user_keywords.where(:name => params[:keyword_input]).take.nil? 
                user_input_keyword = UserKeyword.new
                user_input_keyword.name = params[:keyword_input]
                user_input_keyword.user_id = current_user.id
                user_input_keyword.status = false
                user_input_keyword.save
                    
                if KeywordPool.where(:name => params[:keyword_input]).take.nil?
                    user_input_keyword_inpool = KeywordPool.new
                    user_input_keyword_inpool.name = params[:keyword_input]
                    user_input_keyword_inpool.user_input_count = 1 
                    user_input_keyword_inpool.save
                elsif KeywordPool.where(:name => params[:keyword_input]).take.user_input_count < 9999
                    user_input_keyword_inpool = KeywordPool.where(:name => params[:keyword_input]).take
                    user_input_keyword_inpool.user_input_count = user_input_keyword_inpool.user_input_count+1
                    user_input_keyword_inpool.save
                end
            end
        elsif ((params[:keyword] != nil) && (params[:keyword_input] == ""))
            params[:keyword][:chkboxes].each do |keyword_input_all|
                #등록 절차 chkbox만 받을 때
                if current_user.user_keywords.where(:name => keyword_input_all).take.nil?
                    user_input_keyword = UserKeyword.new
                    user_input_keyword.name = keyword_input_all
                    user_input_keyword.user_id = current_user.id
                    user_input_keyword.status = false
                    user_input_keyword.save
                        
                    if KeywordPool.where(:name => keyword_input_all).take.nil?
                        user_input_keyword_inpool = KeywordPool.new
                        user_input_keyword_inpool.name = keyword_input_all
                        user_input_keyword_inpool.user_input_count = 1 
                        user_input_keyword_inpool.save
                    elsif KeywordPool.where(:name => keyword_input_all).take.user_input_count < 9999
                        user_input_keyword_inpool = KeywordPool.where(:name => keyword_input_all).take
                        user_input_keyword_inpool.user_input_count = user_input_keyword_inpool.user_input_count+1
                        user_input_keyword_inpool.save
                    end
                end   
            end
        else
        end
        
        redirect_to "/khutice/standard_keyword_plus/"
    end
    
    def standard_keyword_plus
                
        keywords_inpool = KeywordPool.all
        keywords_inpool.each do |x|
            if x.user_input_count >= 3 && StandardKeyword.where(:name => x.name).take.nil?
                standard_keyword_plus = StandardKeyword.new
                standard_keyword_plus.name = x.name
                standard_keyword_plus.save
            end
        end
        
        redirect_to "/khutice/matching_notice"
    end
    
    def matching_notice
        
        each_user_keyword_by_current_user = current_user.user_keywords.where(:status => false)
            #current_user의 user_keyword를 하나씩 뽑는다.
            # 뽑은 키워드의 아이디를 변수에 저장한다
            # 노티스타이틀을 쭉 돌리고, 노티스 키워드.all를 불러온다
            # 노티스 키워드를 쭉 돌리고.name의 id를 불러온다.
            # 그걸 저장한다.
            # 변수1 << 변수2한다.
        each_user_keyword_by_current_user.ids.each do |each_user_keyword_id|
           
            unless StandardKeyword.where(:name => each_user_keyword_by_current_user.find(each_user_keyword_id).name).take.nil?
                
                Noticetitle.all.each do |notice_keywords_check|
                    #current_user.user_keywords.where(:name => each_user_keyword_by_current_user.name).take.notice_keywords.where(:name => each_user_keyword_by_current_user.name).all.each do |x|
                            unless notice_keywords_check.notice_keywords.where(:name => each_user_keyword_by_current_user.find(each_user_keyword_id).name).take.nil?
                                notice_keywords_check_id = notice_keywords_check.notice_keywords.where(:name => each_user_keyword_by_current_user.find(each_user_keyword_id).name).take.id
                                
                                match_link = current_user.user_keywords.find(each_user_keyword_id) #유저키워드 선택
                                match_link.link = notice_keywords_check.notice_keywords.find(notice_keywords_check_id).noticetitle.link
                                match_link.save
                                
                                current_user.user_keywords.find(each_user_keyword_id).notice_keywords << notice_keywords_check.notice_keywords.find(notice_keywords_check_id)  
                            end
                    
                    #end
                end
            end
        status_change = current_user.user_keywords.find(each_user_keyword_id)
        status_change.status = true
        status_change.save
        end
        redirect_to "/khutice/user_keyword_input_write"
    end
    
    def destroy
        one_choice = current_user.user_keywords.where(:id => params[:id]).take
        unless ["장학","아르바이트","근로","채용","해외","공모","대회","봉사","인턴","연수","교환","유학","전과","다전공","특강","리쿠르팅","계절"].include? one_choice.name
            each_keyword_pool = KeywordPool.where(:name => one_choice.name).take
            each_keyword_pool.user_input_count = each_keyword_pool.user_input_count-1
            each_keyword_pool.save
        end
        one_choice.destroy
        
        redirect_to "/khutice/user_keyword_input_write/"
    end
    
    def automatic
        #자동으로 돌리자
        #1.돌릴것. 회원가입해서 최초받는 키워드 -> 기존 공지사항 보내주기
        #2.돌릴것. 12시간마다 한번 update_크롤 - > 걸었음.
        #3.돌릴것. 12시간마다 한번 keyword_pool -> 스탠다드풀 업데이트  > 걸었음.
        #4.만약 스탠다드풀이 업데이트 되었다면 키워드 쭉 새로 매칭
        Rufus::Scheduler.singleton.every '24h' do
            puts "얘는 10초마다 돌아요"
        end
        Rufus::Scheduler.singleton.every '4s' do
            puts "얘는 4초마다 돌아요"
        end
    end

    def dislike_admin
    #x.notice_title을 받아서 Noticetitle과 그 이하 놈들을 날리자.
        UserTeach.where(user_name: "admin").all.each do |x|
            Noticetitle.where(title: x.notice_title).take.destroy
        end
    end

    def dislike_enroll
        
        # 일단 찾는다. 모델중 이름, 타이틀, 노티스키워드가 없는지.
        if  UserTeach.where(user_name: current_user.user_name).where(notice_title: params[:notice_title]).where(notice_keyword: params[:notice_keyword]).take.nil?
            
            #user_teach model에 log저장
            user_teach = UserTeach.new
            user_teach.email = current_user.email
            user_teach.user_name = current_user.user_name
            user_teach.major = current_user.major
            user_teach.notice_title = params[:notice_title]
            user_teach.notice_category = params[:notice_category]
            user_teach.notice_link = params[:notice_link]
            user_teach.notice_keyword = params[:notice_keyword]
            user_teach.user_keyword_name = params[:user_keyword_name]
            user_teach.user_dislike = 1
            user_teach.save
            
            #실제 삭제
            #notice_title의 notice_keyword를 날려서 매칭안되게 한다.
            notice_id_search = Noticetitle.where(title: params[:notice_title]).take.id
            current_user.user_keywords.where(name: params[:user_keyword_name]).take.notice_keywords.where(noticetitle_id: notice_id_search).take.destroy
            
        end
        redirect_to "/khutice/user_keyword_input_write"
    end

end
