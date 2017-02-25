class ImmediateMailer < ApplicationMailer
    def determine_subject(item)
        if !item["claim_id"].nil?
            @claim = Claim.find(item["claim_id"])
        end

        if !item["prediction_id"].nil?
            @prediction = Prediction.find(item["prediction_id"])
        end

        if !item["expert_id"].nil?
            @expert = Expert.find(item["expert_id"])
        end

        if !item["category_id"].nil?
            @category = Category.find(item["category_id"])
        end

        if !item["user_id"].nil?
            @user = User.find(item["user_id"])
        end


        case item.item_type
        when "new_claim_comment"
            return "New comment on '#{@claim.title}'"

        when "expert_updated"
            return "'#{@expert.name}' has been updated!"

        when "expert_added_to_claim"
            return "#{@expert.name} has been added to '#{@claim.title}"

        when "claim_status_changed"
            if @claim.vote_value >= 0.5
                @status = "right"
            else
                @status = "wrong"
            end
            return "'#{@claim.title}' is #{@status}!"

        when "new_prediction_comment"
            return "New comment on '#{@prediction.title}'"

        when "claim_updated"
            return "'#{@claim.title} has been updated!"

        when "expert_added_to_prediction"
            return "#{@expert.name} has been added to '#{@prediction.title}"

        when "prediction_status_changed"
            if @prediction.vote_value >= 0.5
                @status = "right"
            else
                @status = "wrong"
            end
            return "'#{@prediction.title}' is #{@status}!"

        when "new_expert_comment"
            return "New comment on #{@expert.name}"

        when "prediction_updated"
            return "'#{@prediction.title} has been updated!"

        when "claim_added_to_expert"
            return "'#{claim.title}' has been added to #{@expert.name}"

        when "prediction_added_to_expert"
            return "'#{@prediction.title}' has been added to #{@expert.name}"

        when "expert_claim_status_changed"
            if @claim.vote_value >= 0.5
                @status = "right"
            else
                @status = "wrong"
            end
            return "A claim made by #{@expert.name}, '#{@claim.title}', is #{@status}!"

        when "expert_prediction_status_changed"
            if @prediction.vote_value >= 0.5
                @status = "right"
            else
                @status = "wrong"
            end
            return "A prediction made by #{@expert.name}, '#{@prediction.title}', is #{@status}!"

        else
            return ""
        end
    end


    def as_they_happen(item)
        p "AS THEY HAPPEN"
        @item = item
        @user = User.find_by_id(item.user_id)
        @subject = determine_subject(item)

        @content = @comment.content
        @content = "" if @comment.content.nil?

        @send_message = mail(to: @user.email, from: ENV['default_email_address'], subject: @subject)

    end
end
