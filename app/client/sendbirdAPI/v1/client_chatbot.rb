require 'faraday'
require 'json'

class SendbirdAPI::V1::ClientChatbot
  APPLICATION_ID = Rails.application.credentials.sendbird[:application_id]
  API_TOKEN_CHAT = Rails.application.credentials.sendbird[:api_token_chat]
  ADMIN_ID = Rails.application.credentials.sendbird[:admin_id]
  CHATBOT_ID = Rails.application.credentials.sendbird[:chatbot_id]
  BASE_URL_CHAT = "https://api-#{APPLICATION_ID}.sendbird.com/v3"

  def create_customer(user_id, nickname)
    response = request(
      method: :post,
      endpoint: "#{BASE_URL_CHAT}/users",
      body: {
      user_id: user_id,
      nickname: nickname,
      profile_url: "https://sendbird.com/main/img/profiles/profile_05_512px.png",
      issue_access_token: true,
      session_token_expires_at: ((Time.now + 7.days).to_i * 1000)
      })
    handle_response(response)
  end

  def check_user?(user_id)
    response = request(
      method: :get,
      endpoint: "#{BASE_URL_CHAT}/users/#{user_id}"
      )
    if response.key?('error')
      Rails.logger.error("Error: #{response['code']}, #{response['message']}")
      false
    else
      true
    end
  end

  def create_channel(user_id, channel_name, channel_url)
    response = request(
      method: :post,
      endpoint: "#{BASE_URL_CHAT}/group_channels",
      body: {
      user_ids: [user_id, ADMIN_ID, CHATBOT_ID],
      is_distinct: false,
      name: channel_name,
      channel_url: channel_url
      }.compact)

    handle_response(response)
  end

  def check_channel?(channel_url)
    response = request(
      method: :get,
      endpoint: "#{BASE_URL_CHAT}/group_channels/#{channel_url}"
      )
    if response.key?('error')
      Rails.logger.error("Error: #{response['code']}, #{response['message']}")
      false
    else
      true
    end
  end

  def send_message(user_id, channel_url, message)
    response = request(
      method: :post,
      endpoint: "#{BASE_URL_CHAT}/group_channels/#{channel_url}/messages",
      body: {
      message_type: "MESG",
      user_id: user_id,
      message: message
      })
    handle_response(response)
  end

  def chat_messages(channel_url)
    response = request(
      method: :get,
      endpoint: "#{BASE_URL_CHAT}/group_channels/#{channel_url}/messages?message_ts=0&reverse=true"
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
