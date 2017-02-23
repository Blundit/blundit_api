class ExpertMailer < ApplicationMailer
    def new_comment(item)
        @user = User.find_by_id(item.user_id)
        @comment = item.comment
        @expert = item.expert

        @subject = "New Comment on '#{@expert.title}"
        @content = @comment.title
        @content = "" if @comment.title.nil?
            

        mail(to: ENV['default_email_address'], subject: @subject)
    end


    def expert_updated(item)

    end


    def prediction_added_to_expert(item)

    end

    
    def claim_added_to_expert(item)

    end
end
