class ClaimWorker
  include Sidekiq::Worker

  def perform(attrs)
    p "Processing Claim"
    p attrs["id"]

    @claim = Claim.find_by_id(attrs["id"])

    if !@claim.nil?
      @claim.calc_status
    end
  end
end
