class ExpertCategoryAccuracy < ApplicationRecord
    belongs_to :expert
    belongs_to :category

    def calculate_accuracy
        if self.correct + self.incorrect > 0
            self.accuracy = self.correct / (self.correct + self.incorrect)
            self.save
        end
    end
end
