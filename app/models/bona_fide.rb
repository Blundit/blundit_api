class BonaFide < ApplicationRecord
    belongs_to :expert

    before_save :determine_bona_fide_type
    def determine_bona_fide_type

    end
end
