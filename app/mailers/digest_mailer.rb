class DigestMailer < ApplicationMailer
    def daily(items)
        @user = User.find_by_id(items.first.user_id)
        @subject = "It's your daily digest!"
        @items = items

        @send_message = mail(to: @user.email, from: ENV['default_email_address'], subject: @subject)
    end


    def weekly(items)
        @user = User.find_by_id(items.first.user_id)
        @subject = "It's your weekly digest!"
        @items = items

        @send_message = mail(to: @user.email, from: ENV['default_email_address'], subject: @subject)
    end


    def monthly(items)
        @user = User.find_by_id(items.first.user_id)
        @subject = "It's your monthly digest!"
        @items = items

        @send_message = mail(to: @user.email, from: ENV['default_email_address'], subject: @subject)
    end
end