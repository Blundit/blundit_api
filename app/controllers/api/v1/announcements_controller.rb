module Api::V1
  class AnnouncementsController < ApiController
    def get
      if params[:slug]
        @announcements = Announcement.get(params[:slug])
      else
        @announcements = Announcement.active
      end
    end
  end
end