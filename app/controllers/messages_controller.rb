class MessagesController < ApplicationController

  # For general inbox filtering. There are convenience methods for each of the "classic" messaging behaviors, but this is the fun one:
  # Options:
  # - page: which page of results to get, defaults to 1
  # - per_page: how many pages to retrieve, defaults to 100, max is 500
  # - n_days: How many days into the past to we want to query?  Defaults to 30, max is 365 - IGNORED FOR THREADS
  # - thread_id: Get an individual thread.  Useful for getting all the messages between a set of users (group messaging)

  before_action :set_pagination, only: [:index, :unread, :read, :sent]

  # Not sure we need this since the other cases cover things, maybe just for fetching threads.
  # If I had more time, I'd clean this up.
  def index
    query = Message

    thread_id = params.fetch(:thread_id, nil)

    if thread_id.present?
      query = query.where(thread_id: params[:thread_id])
    else
      query = query.where(["created_at >= ?", @n_days.days.ago.beginning_of_day])
    end

    query = query.order("created_at desc")

    @messages = query.includes(:sender).paginate(page: @page, per_page: @per_page)
  end

  # Get the unread messages for a recipient
  def unread
    user_id = params.fetch(:user_id, nil)

    if user_id.blank?
      invalid_params([:user_id]) and return
    end

    user = User.find(params[:user_id])

    query = user.unread_messages.where(["messages.created_at >= ?", @n_days.days.ago.beginning_of_day]).order("messages.created_at desc")

    @messages = query.includes(:sender).paginate(page: @page, per_page: @per_page)

    render 'index'
  end

  # Get the read messages for a recipient
  def read
    user_id = params.fetch(:user_id, nil)

    if user_id.blank?
      invalid_params([:user_id]) and return
    end

    user = User.find(params[:user_id])

    query = user.read_messages.where(["messages.created_at >= ?", @n_days.days.ago.beginning_of_day]).order("messages.created_at desc")

    @messages = query.includes(:sender).paginate(page: @page, per_page: @per_page)
    render 'index'
  end

  # Get messages sent by a user id
  def sent
    user_id = params.fetch(:user_id, nil)

    if user_id.blank?
      invalid_params([:user_id]) and return
    end

    user = User.find(params[:user_id])

    query = user.sent_messages.where(["messages.created_at >= ?", @n_days.days.ago.beginning_of_day]).order("messages.created_at desc")

    @messages = query.includes(:sender).paginate(page: @page, per_page: @per_page)
    render 'index'
  end

  # Get an individual message
  def show
    @message = Message.find(params[:id])
  end

  # Create a new message
  def create
    @message = Message.new(message_params)
    status = 200
    if !@message.save
      status = 406
      @errors = response_errors(@message)
    end
    render 'show', status: status
  end

  # Mark a received message read
  # Requires a user_id (the "viewer"/"recipient")
  def mark_read
    @message_ticket = MessageTicket.where(user_id: params[:user_id], message_id: params[:id]).first
    if @message_ticket.nil?
      head :not_found
    else
      @message_ticket.update(read: true)
      head :ok
    end
  end

  protected

  def message_params
    params.require(:message).permit(:sender_id, :body, recipient_ids: [])
  end

  def set_pagination
    @page = params.fetch(:page, '1').to_i
    @per_page = params.fetch(:per_page, '100').to_i
    @n_days = params.fetch(:n_days, '30').to_i

    if @page < 1
      @page = 1
    end

    if @per_page < 1 || @per_page > 500
      @per_page = 100
    end

    if @n_days < 1 || @n_days > 365
      @n_days = 365
    end
  end

end
