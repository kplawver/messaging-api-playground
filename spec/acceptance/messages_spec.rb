require 'rails_helper'
require 'rspec_api_documentation/dsl'

# This doesn't work yet, because rspec_api_documentation is a fiddly monster to set up.
# BUT, once it's set up, it creates great docs _and_ API tests.
# If I had more time, _this_ is how I would generate documentation!

resource "Messages" do
  explanation "For getting messages."

  header "Content-Type", "application/json"

  get '/messages' do
    let(:user_one) { create :user }
    let(:user_two) { create :user }
    let(:user_three) { create :user }
    let(:user_four) { create :user }
    let(:message_one) { create :message, sender: user_one, recipient_ids: [user_two.id] }
    let(:message_two) { create :message, sender: user_two, recipient_ids: [user_one.id] }
    let(:message_three) { create :message, sender: user_three, recipient_ids: [user_one.id, user_two.id] }

    example_request "Get all messages" do
      expect(response.status).to eq(200)
    end

  end

end
