class WeeklyDigestWorker
  include Sidekiq::Worker

  def perform
    NotificationQueue::process_weekly_digests
  end
end