class CustomerClient::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  PAYMONGO_WEBHOOK_SECRET = Rails.application.credentials.paymongo[:webhook_secret]

  def paymongo_webhook
    payload = JSON.parse(request.body.read)

    # Verify webhook signature
    verify_signature(request)

    # Process the webhook payload
    event_type = payload['type']
    case event_type
    when 'payment.success'
      handle_payment_success(payload)
    when 'payment.failed'
      handle_payment_failure(payload)
    else
      # Handle other event types if needed
      Rails.logger.warn("Received unsupported event type: #{event_type}")
    end

    head :ok
  rescue => e
    # Handle webhook processing errors
    Rails.logger.error("Error processing webhook: #{e.message}")
    head :unprocessable_entity
  end

  private

  def verify_signature(request)
    signature_header = request.headers['Paymongo-Signature']
    raise 'No signature provided' unless signature_header

    payload_body = request.body.read
    expected_signature = OpenSSL::HMAC.hexdigest('SHA256', PAYMONGO_WEBHOOK_SECRET, payload_body)

    raise 'Invalid signature' unless ActiveSupport::SecurityUtils.secure_compare(expected_signature, signature_header)
  end


  def handle_payment_success(payload)

    redirect_to customer_client_success_path
  end

  def handle_payment_failure(payload)
    # Extract relevant information from the payload
    payment_id = payload['data']['id']
    error_message = payload['data']['attributes']['error_message']

    Rails.logger.error("Payment failed for payment ID #{payment_id}: #{error_message}")

    # Redirect to a failure page or notify the customer
    redirect_to customer_client_failed_path
  end

end
