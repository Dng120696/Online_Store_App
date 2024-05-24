class ChatbotController < ApplicationController
  before_action :initialize_chatbot_client, :authenticate_user!

  def create_customer
    @custom_user_id = "#{current_user.id}_#{current_user.firstname.gsub(' ', '_')}"
    @default_profile_url = "https://sendbird.com/main/img/profiles/profile_05_512px.png"
    @session_token_expires_at = (Time.now + 7.days).to_i * 1000
    if request.post?
      customer_data = customer_params.merge(
        user_id: @custom_user_id,
        profile_url: customer_params[:profile_url].presence || @default_profile_url,
        issue_access_token: true,
        session_token_expires_at: @session_token_expires_at,
        metadata: {
          font_preference: "times new roman",
          font_color: "black"
        }
      )
      response = @chatbot_client.create_customer(customer_data)
      render json: response
    else
      render :create_customer
    end
  end

  def send_message
    if request.post?
      user_id = "#{current_user.id}_#{current_user.firstname.gsub(' ', '_')}"
      message = params[:message]
      if @chatbot_client.user_in_channel?(user_id)
        response = @chatbot_client.send_message(user_id, message)
        render json: response
      else
        add_user_response = @chatbot_client.add_user_to_channel(user_id)
        if add_user_response[:error]
          render json: add_user_response, status: add_user_response[:status]
        else
          response_new = @chatbot_client.send_message(user_id, message)
          render json: response_new
        end
      end
    else
      render :send_message
    end
  end

  private

  def initialize_chatbot_client
    @chatbot_client ||= SendbirdAPI::V1::ClientChatbot.new
  end

  def customer_params
    params.require(:customer).permit(:nickname, :profile_url)
  end
end
