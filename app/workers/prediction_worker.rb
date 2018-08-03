class PredictionWorker
  include Sidekiq::Worker

  def perform(attrs)
    @prediction = Prediction.find_by_id(attrs["id"])

    if !@prediction.nil?
      @prediction.create_vote_set
      @prediction.calc_status
    end
  end
end
