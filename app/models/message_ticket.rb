class MessageTicket < ApplicationRecord
  belongs_to :user
  belongs_to :message

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

end
