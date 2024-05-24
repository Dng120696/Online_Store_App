require 'faraday'
require 'json'

class SendbirdAPI::V1::ClientChatbot
  APPLICATION_ID = Rails.application.credentials.sendbird[:application_id]
  API_TOKEN_CHAT = Rails.application.credentials.sendbird[:api_token_chat]
  API_KEY_DESK = Rails.application.credentials.sendbird[:api_key_desk]
  BOT_CHANNEL_URL = Rails.application.credentials.sendbird[:bot_channel_url]
  BASE_URL_CHAT = "https://api-#{APPLICATION_ID}.sendbird.com/v3"


  def create_customer(customer_data)
    response = request(
      method: :post,
      endpoint: "#{BASE_URL_CHAT}/users",
      body: customer_data,
    )
    handle_response(response)
  end

  def user_in_channel?(user_id)
    response = request(
      method: :get,
      endpoint: "#{BASE_URL_CHAT}/users/#{user_id}/my_group_channels"
    )
    channels = response['channels'] || []
    channels.any? { |channel| channel['channel_url'] == BOT_CHANNEL_URL }
  end

  def add_user_to_channel(user_id)
    response = request(
      method: :post,
      endpoint: "#{BASE_URL_CHAT}/group_channels/#{BOT_CHANNEL_URL}/invite",
      body: { user_ids: [user_id] }
    )
    handle_response(response)
  end

  def send_message(user_id, message)
    response = request(
      method: :post,
      endpoint: "#{BASE_URL_CHAT}/group_channels/#{BOT_CHANNEL_URL}/messages",
      body: {
        message_type: "MESG",
        user_id: user_id,
        message: message
      }
    )
    handle_response(response)
  end

  private

  def connection
    Faraday.new(url: BASE_URL_CHAT) do |faraday|
      faraday.request :json
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def request(method:, endpoint:, body: nil)
    response = connection.public_send(method) do |req|
      req.url endpoint
      req.headers['Content-Type'] = 'application/json; charset=utf8'
      req.headers['Api-Token'] = API_TOKEN_CHAT
      req.body = body.to_json unless body.nil?
    end
    JSON.parse(response.body)
  end

  def handle_response(response)
    if response.is_a?(Hash) && response.key?('error')
      error_code = response['code']
      error_message = response['message']
      Rails.logger.error("Error Code: #{error_code}, Message: #{error_message}")
      response
    else
      response
    end
  end
end
