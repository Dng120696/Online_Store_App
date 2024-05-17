class BigcommerceAPI::V1::Client

  STORE_HASH = Rails.application.credentials[:big_commerce_api][:store_hash]
  ACCESS_TOKEN = Rails.application.credentials.big_commerce_api[:access_token]
  CLIENT_ID = Rails.application.credentials.big_commerce_api[:client_id]
  CLIENT_SECRET = Rails.application.credentials.big_commerce_api[:client_secret]
  BASE_URL = "https://api.bigcommerce.com".freeze

  def get_products
    request(
      method: :get,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/products"
    )
  end

  def create_product(params)
    request(
      method: :post,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/products",
      body: params
    )
  end
  def create_customer
    request(
      method: :post,
      endpoint: "/stores/#{STORE_HASH}/v3/customers",
      body: [{
              "email": "sample321@example.com",
              "first_name": "sample321",
              "last_name": "sample12345",
              "customer_group_id": 0,
              "addresses": [
                {
                  "address1": "Addr 1",
                  "address_type": "residential",
                  "city": "San Francisco",
                  "company": "History",
                  "country_code": "US",
                  "postal_code": "33333",
                  "state_or_province": "California",
                  "first_name": "sample321",
                  "last_name": "sample12345"
                }
            ]
      }]
    )
  end

  def get_single_product
    request(
      method: :get,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/products/113",
     )
  end
  def get_image_of_single_product(id)
    request(
      method: :get,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/products/#{id}/images",
     )
  end

  def get_all_categories
    request(
      method: :get,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/categories",
     )
  end

  private
  def request(method:, endpoint:,body: {})
    response = connection.public_send(method, endpoint) do |request|
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      request.headers['X-Auth-Token'] = ACCESS_TOKEN
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
