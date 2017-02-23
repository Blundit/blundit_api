class PredictionMailer < ApplicationMailer
    def new_comment(item)
        @user = User.find_by_id(item.user_id)
        @comment = Comment.find_by_id(item.comment_id)
        @prediction = Prediction.find_by_id(item.prediction_id)

        @subject = "New Comment on '#{@prediction.title}'"
        @content = @comment.content
        @content = "" if @comment.content.nil?

        @send_message = mail(to: @user.email, from: ENV['default_email_address'], subject: @subject)

        # TODO: Add error trap, for reporting purposes.
    end


    def prediction_updated(item)

    end


    def expert_added_to_prediction(item)

    end


    def status_changed(item)

    end
end
