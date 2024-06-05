class Owner::ChatbotsController < ApplicationController
  before_action :authenticate_admin!
  before_action :initialize_chatbot_client

  def index
    @channel_list = @chatbot_client.channel_list
    @messages = @chatbot_client.chat_messages(params[:channel_url])
  end

  def send_message
    @chatbot_client.send_message(@chatbot_client.admin_id, params[:channel_url], params[:message])
    redirect_to request.referrer
  end

  private

  def initialize_chatbot_client
    @chatbot_client ||= SendbirdAPI::V1::ClientChatbot.new
  end
end
