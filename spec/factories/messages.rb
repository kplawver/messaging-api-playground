FactoryBot.define do
  factory :message do
    sender { nil }
    recipient_ids { [] }
    body { Faker::Lorem.paragraph }
  end
end
