class User < ApplicationRecord
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :message_tickets
  has_many :messages, through: :message_tickets

  has_many :unread_message_tickets, -> { where(read: false) }, class_name: 'MessageTicket'
  has_many :unread_messages, through: :unread_message_tickets, source: :message

  has_many :read_message_tickets, -> { where(read: true) }, class_name: 'MessageTicket'
  has_many :read_messages, through: :read_message_tickets, source: :message
end
