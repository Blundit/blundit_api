class ClaimWorker
  include Sidekiq::Worker

  def perform(msg)
    # Do something
    @claim = Claim.find(msg)
    p "Showing Claim:"
    p @claim

  end
end
