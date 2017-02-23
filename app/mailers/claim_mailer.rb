class ClaimMailer < ApplicationMailer
    def new_comment(item)
        @user = User.find_by_id(item.user_id)
        @comment = item.comment
        @claim = item.claim

        @subject = "New Comment on '#{@claim.title}"
        @content = @comment.title
        @content = "" if @comment.title.nil?

        mail(to: ENV['default_email_address'], subject: @subject)
    end


    def claim_updated(item)

    end


    def expert_added_to_claim(item)

    end
end
