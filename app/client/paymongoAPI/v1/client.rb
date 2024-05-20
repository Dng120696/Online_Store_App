class PaymongoAPI::V1::Client

  BASE_URL = 'https://api.paymongo.com/v1'
  PUBLIC_KEY = ''
  SECRET_KEY = ''




  def create_payment_intent(amount, currency)
    request(
      method: :post,
      endpoint: '/payment_intents',
      body: {
        data: {
          attributes: {
            amount: amount,
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
    )
  end

  def attach_payment_method_to_intent(payment_intent_id, payment_method_id)
    request(
      method: :post,
      endpoint: "/payment_intents/#{payment_intent_id}/attach",
      body: {
        data: {
          attributes: {
            payment_method: payment_method_id,
            client_key: Rails.application.credentials.dig(:paymongo, :public_key)
          }
        }
      }
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
      }
    )
  end

  def create_payment_method_gcash(billing_details)
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
      }
    )
  end

  private
  def request(method:, endpoint:,body: {})
    response = connection.public_send(method, endpoint) do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = "Basic #{Base64.strict_encode64(SECRET_KEY + ':')}"

      request.body = body.to_json
    end
    handle_response(response)
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  def handle_response(response)
    if response.success?
      JSON.parse(response.body)
    elsif response.status == 404
      raise "Resource not found"
    else
      raise "Unknown error occurred: #{response.status}"
    end
  rescue Faraday::Error => e
    raise "Connection error: #{e.message}"
  rescue JSON::ParserError => e
    raise "Error parsing response: #{e.message}"
  end
end
