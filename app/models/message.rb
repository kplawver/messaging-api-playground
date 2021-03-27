class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  has_many :message_tickets

  before_create :set_participant_ids
  before_create :set_thread_id
  after_create :create_message_tickets

  validates :body, presence: true

  scope :with_participants, -> (user_ids) {
    if !user_ids.is_a?(Array)
      user_ids = [user_ids]
    end
    where("participant_ids @> ARRAY[?]::integer[]", user_ids)
  }

  scope :with_all_particpants, -> (user_ids) {
    if !user_ids.is_a?(Array)
      user_ids = [user_ids]
    end
    thread_id = self.generate_thread_id(user_ids)
    where(thread_id: thread_id)
  }

  def self.generate_thread_id(user_ids)
    Digest::UUID.uuid_v5('Message', user_ids.sort.join('-'))
  end

  def recipients
    @recipients ||= User.where(id: recipient_ids)
  end

  private

  def create_message_tickets
    recipient_ids.each do |id|
      message_tickets.create(user_id: id)
    end
  end

  def set_participant_ids
    self.participant_ids = (recipient_ids + [sender_id]).uniq.compact.sort
  end

  def set_thread_id
    self.thread_id = self.class.generate_thread_id(participant_ids)
  end

end
