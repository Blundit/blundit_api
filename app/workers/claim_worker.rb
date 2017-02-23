class ClaimWorker
  include Sidekiq::Worker

  def perform(attrs)
    @claim = Claim.find_by_id(attrs["id"])

    if !@claim.nil?
      @claim.calc_status
    end
  end
end
