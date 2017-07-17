class Usermailer < ApplicationMailer
    def notice title, content, user_id
    
                @content = content
                address = User.where(:id => user_id).take.email
 
                mail from: 'milkproduct@likelion.org',
                to: address,
                subject: title,
                content_type: "text/html"
                
                
        
    end
end
