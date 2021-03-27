require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  render_views

  before(:each) do
    set_json_headers
  end

  let!(:user_one) { create :user }
  let!(:user_two) { create :user }
  let!(:user_three) { create :user }
  let!(:user_four) { create :user }
  let!(:message_one) { create :message, sender: user_one, recipient_ids: [user_two.id] }
  let!(:message_two) { create :message, sender: user_two, recipient_ids: [user_one.id] }

  let!(:message_three) { create :message, sender: user_three, recipient_ids: [user_one.id, user_two.id] }

  let!(:message_four) { create :message, sender: user_one, recipient_ids: [user_two.id] }
  let!(:message_five) { create :message, sender: user_two, recipient_ids: [user_one.id] }


  describe 'index' do
    it 'should return all messages when given no parameters' do
      response = get :index

      o = parse_response(response, 200)

      expect(o[:total_entries]).to eq(Message.count)
    end

    it 'should return only thread messages given a thread id' do
      response = get :index, params: { thread_id: message_one.thread_id }

      o = parse_response(response, 200)
      expect(o[:total_entries]).to eq(Message.where(thread_id: message_one.thread_id).count)
      # This really belongs in the model, but who has time?
      expect(message_one.thread_id).to eq(message_two.thread_id)
    end
  end

  describe 'unread' do
    it 'should return a 406 when not given a user_id' do
      response = get :unread
      expect(response.status).to eq(406)
    end

    it 'should only return messages unread by the user' do
      response = get :unread, params: { user_id: user_one.id }
      o = parse_response(response,200)
      expect(o[:total_entries]).to eq(user_one.unread_messages.count)
    end
  end

  describe 'read' do
    it 'should return a 406 when not given a user_id' do
      response = get :read
      expect(response.status).to eq(406)
    end

    it 'should return only read messages given a user_id' do
      ticket = MessageTicket.where(user: user_one, message: message_five).first

      ticket.update!(read: true)

      response = get :read, params: { user_id: user_one.id }
      o = parse_response(response,200)
      expect(o[:total_entries]).to eq(user_one.read_messages.count)
    end
  end

  describe 'sent' do
    it 'should return a 406 when not given a user_id' do
      response = get :sent
      expect(response.status).to eq(406)
    end

    it 'should return only sent messages given a user_id' do
      response = get :sent, params: { user_id: user_one.id }
      o = parse_response(response,200)
      expect(o[:total_entries]).to eq(user_one.sent_messages.count)
    end
  end

  describe 'show' do
    it 'should return a message' do
      response = get :show, params: { id: message_one.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'mark_read' do
    it 'should mark a message read given a valid user id and message id' do
      response = post :mark_read, params: { id: message_three.id, user_id: user_one.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'create' do
    it 'should create a message' do
      response = post :create, params: { sender_id: user_one.id, recipient_ids: [user_two.id], body: Faker::Lorem.paragraph }
      o = parse_response(response, 200)
      expect(o[:message].nil?).to eq(false)
      expect(o[:errors].nil?).to eq(true)
    end

    it 'should fail given invalid input' do
      response = post :create, params: { sender_id: user_one.id, recipient_ids: [user_two.id] }
      o = parse_response(response, 406)
      expect(o[:message][:id].nil?).to eq(true)
      expect(o[:errors].nil?).to eq(false)
    end
  end

end
