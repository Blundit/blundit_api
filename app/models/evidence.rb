require 'open-uri'

class Evidence < ApplicationRecord
    has_one :claim
    has_one :prediction


    attr_reader :contributions_list
    def contributions_list
        {
                created_evidence: "Created Evidence",
                edited_evidence: "Edited Evidence",
                destroyed_evidence: "Destroyed Evidence"
        }
    end

end
