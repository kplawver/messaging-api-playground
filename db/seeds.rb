# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

senders = []
recipients = []

10.times do
  senders << FactoryBot.create(:user).id
  recipients << FactoryBot.create(:user).id
end

puts "senders"
puts senders
puts "recipients"
puts recipients

10.times do |i|
  sender = senders.sample
  recievers = recipients.sample(rand(1..recipients.length))

  # initial message:
  initial = FactoryBot.create :message, sender_id: sender, recipient_ids: recievers

  puts "Message #{i}: sender_id: #{initial.sender_id}, recipient_ids: #{initial.recipient_ids}"

  # some replies:
  rand(1..30).times do |i|
    recipient_ids = initial.recipient_ids.shuffle
    reply_sender = recipient_ids.pop
    recipient_ids << initial.sender_id

    FactoryBot.create :message, sender_id: reply_sender, recipient_ids: recipient_ids
  end

end
