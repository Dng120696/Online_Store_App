class BigcommerceAPI::V1::Client

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
