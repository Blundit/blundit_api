class Publication < ApplicationRecord
    belongs_to :expert

    before_save :determine_publication_type
    def determine_publication_type

    end
end
