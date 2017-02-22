class NotificationQueueItem < ApplicationRecord
    has_one :claim, optional: true
    has_one :prediction, optional: true
    has_one :expert, optional: true
    has_one :comment, optional: true
    has_one :category, optional: true
end
