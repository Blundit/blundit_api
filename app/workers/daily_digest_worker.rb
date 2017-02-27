require 'sidekiq-scheduler'

class DailyDigestWorker
  include Sidekiq::Worker

  def perform
    NotificationQueue::process_daily_digests
  end
end
