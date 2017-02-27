class MonthlyDigestWorker
  include Sidekiq::Worker

  def perform
    NotificationQueue::process_monthly_digests
  end
end