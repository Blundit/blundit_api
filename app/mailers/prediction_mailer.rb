class PredictionClaimMailer < ApplicationMailer
    def new_comment(item)
        @user = User.find_by_id(item.user_id)
        @comment = item.comment
        @prediction = item.prediction

        @subject = "New Comment on '#{@prediction.title}"
        @content = @comment.title
        @content = "" if @comment.title.nil?
            

        mail(to: ENV['default_email_address'], subject: @subject)
    end


    def prediction_updated(item)

    end


    def expert_added_to_prediction(item)

    end
end

end
