class ExpertMailer < ApplicationMailer
    def new_comment(item)
        @user = User.find_by_id(item.user_id)
        @comment = Comment.find_by_id(item.comment_id)
        @expert = Expert.find_by_id(item.expert_id)

        @subject = "New Comment on '#{@expert.name}'"
        @content = @comment.content
        @content = "" if @comment.content.nil?

        @send_message = mail(to: @user.email, from: ENV['default_email_address'], subject: @subject)

        # TODO: Add error trap, for reporting purposes.
    end


    def expert_updated(item)

    end


    def prediction_added_to_expert(item)

    end

    
    def claim_added_to_expert(item)

    end


    def claim_status_changed(item)

    end


    def prediction_status_changed(item)

    end
end
