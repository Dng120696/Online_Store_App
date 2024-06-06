class CustomerClient::ChatbotsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_chatbot_client
  before_action :initialize_values
  before_action :initialize_chatbot, only: [:index]

  def index
  end

  def initialize_chatbot
    unless @chatbot_client.check_user?(@custom_user_id)
      @chatbot_client.create_customer(@custom_user_id, @user_nick_name)
    end
    unless @chatbot_client.check_channel?(@channel_url)
      @chatbot_client.create_channel(@custom_user_id, @channel_name, @channel_url)
    end

    if @chatbot_client.check_channel?(@channel_url)
      @get_messages = @chatbot_client.chat_messages(@channel_url)
    end
  end

  def send_message
    send_message = @chatbot_client.send_message(@custom_user_id, @channel_url, params[:message])
    p send_message
    redirect_to root_path
  end

  private

  def initialize_chatbot_client
    @chatbot_client ||= SendbirdAPI::V1::ClientChatbot.new
  end

  def initialize_values
    @custom_user_id = "#{current_user.id}_#{current_user.email.split("@").first}"
    @user_nick_name = "#{current_user.firstname} #{current_user.lastname}"
    @channel_name = "Private Message by #{current_user.firstname}"
    @channel_url = "conversation_channel_url_#{current_user.id}_#{current_user.email.split("@").first}"
  end
end
