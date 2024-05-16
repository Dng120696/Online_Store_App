class BigcommerceAPI::V1::Client

  STORE_HASH = '70covblalz'
  ACCESS_TOKEN = '9vu6pchwo4ypwc3l2tqkyfs9kxb8c8k'
  CLIENT_ID = 'g25s8ax976sxptx8owok977yemgpv9r'
  CLIENT_SECRET = 'e344c95fa48b77d6ed5324220a0a27761e08d80d03d18ecc49e1509f9740b123'
  BASE_URL = "https://api.bigcommerce.com".freeze

  def get_products
    request(
      method: :get,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/products"
    )
  end

  def create_product
    request(
      method: :post,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/products",
      body: {
        "name": "Nike T-shirt",
        "type": "physical",
        "price": "9.99",
        "weight": 1,
        "categories": [23],
        "description": "This is a nike product tshirt with  a price of 9.99",
        "availability": "available",
        "brand_id": 0,
        "inventory_level": 100,
        "images": []
      }
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
  def get_image_of_single_product
    request(
      method: :get,
      endpoint: "/stores/#{STORE_HASH}/v3/catalog/products/113/images",
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
