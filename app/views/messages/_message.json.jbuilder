json.message do
  json.extract! message, :id, :sender_id, :recipient_ids, :participant_ids, :thread_id, :body

  json.sender do
    json.extract! message.sender, :id, :username, :first_name, :last_name
  end

  json.recipients do
    json.partial! 'user', collection: message.recipients, as: :user
  end
end
