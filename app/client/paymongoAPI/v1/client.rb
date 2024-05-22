class PaymongoAPI::V1::Client
  BASE_URL = 'https://api.paymongo.com/v1'
  PUBLIC_KEY = Rails.application.credentials.dig(:paymongo_api_key, :public_key)
  SECRET_KEY = Rails.application.credentials.dig(:paymongo_api_key, :secret_key)

  def create_payment_intent(amount, currency = "PHP")
    body = {
      data: {
        attributes: {
          amount: amount.to_i,
          currency: currency,
          payment_method_allowed: ['card', 'gcash'],
          payment_method_options: {
            card: {
              request_three_d_secure: 'any'
            }
          }
        }
      }
    }

    request(
      method: :post,
      endpoint: '/payment_intents',
      body: body,
      key: SECRET_KEY
    )
  end

  def attach_payment_method_to_intent(payment_intent_id, client_key,payment_method_id,return_url)
    p 'attach'
    request(
      method: :post,
      endpoint: "/payment_intents/#{payment_intent_id}/attach",
      body: {
        data: {
          attributes: {
            payment_method: payment_method_id,
            client_key: client_key,
            return_url: return_url
          }
        }
      },
      key: PUBLIC_KEY
    )
  end

  def create_payment_method_card(card_details)
    request(
      method: :post,
      endpoint: '/payment_methods',
      body: {
        data: {
          attributes: {
            type: 'card',
            details: card_details
          }
        }
      },
      key: PUBLIC_KEY
    )
  end

  def create_payment_method_gcash(billing_details)


    p 'gcash'
    request(
      method: :post,
      endpoint: '/payment_methods',
      body: {
        data: {
          attributes: {
            type: 'gcash',
            billing: billing_details
          }
        }
      },
      key: PUBLIC_KEY
    )
  end

  private

  def request(method:, endpoint:, body: {},key:)
    response = connection.public_send(method, endpoint) do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Basic #{Base64.strict_encode64(key + ':')}"
      request.body = body.to_json
    end

    p response.body
    handle_response(response)
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  def handle_response(response)
    if response.success?
      JSON.parse(response.body).with_indifferent_access
    elsif response.status == 400
      error_details = JSON.parse(response.body)
      raise "Bad Request: #{error_details['errors'].map { |e| e['detail'] }.join(', ')}"
    elsif response.status == 404
      raise "Resource not found"
    elsif response.status == 500
      log_error(response)
      error_details = JSON.parse(response.body) rescue 'Unknown error details'
      raise "Unknown error occurred: #{response.status}, Details: #{error_details}"
    else
      error_details = JSON.parse(response.body) rescue 'Unknown error details'
      raise "Unknown error occurred: #{response.status}, Details: #{error_details}"
    end
  rescue Faraday::Error => e
    raise "Connection error: #{e.message}"
  rescue JSON::ParserError => e
    raise "Error parsing response: #{e.message}"
  end

  def log_error(response)
    Rails.logger.error("Paymongo API Error: #{response.status} - #{response.body}")
  end
end
