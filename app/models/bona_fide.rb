class BonaFide < ApplicationRecord
    belongs_to :expert

    attr_reader :contributions_list
    def contributions_list
        {
            created_bona_fide: "Created Credential",
        }
  end
    before_save :determine_bona_fide_type
    def determine_bona_fide_type

    end
end
