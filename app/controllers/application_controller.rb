class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cart,:set_chatbot_messages, if: :user_signed_in?
  before_action :get_channel_list, if: :admin_signed_in?
  before_action :set_categories

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end

  def landing_page
  end

  def set_cart
    if user_signed_in?
      @cart = current_user.cart
      if @cart
        @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob }) # Include product to avoid N+1 queries
      else
        @cart_items = []
      end
    end
  end



  def set_categories
    @categories = Category.all
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      owner_dashboard_index_path
    elsif resource.is_a?(User)
      root_path
    end
  end

  def get_channel_list
    @chatbot_client ||= SendbirdAPI::V1::ClientChatbot.new
    @channel_list = @chatbot_client.channel_list

  end
  def set_chatbot_messages
  @chatbot_client ||= SendbirdAPI::V1::ClientChatbot.new
  @channel_url = "conversation_channel_url_#{current_user.id}_#{current_user.email.split("@").first}"
  @custom_user_id = "#{current_user.id}_#{current_user.email.split("@").first}"
  @channel_name = "Private Message by #{current_user.firstname}"
  @user_nick_name = "#{current_user.firstname} #{current_user.lastname[0]}"
  unless @chatbot_client.check_user?(@custom_user_id)
    @chatbot_client.create_customer(@custom_user_id, @user_nick_name)
  end
  if @chatbot_client.check_channel?(@channel_url)
    @get_messages = @chatbot_client.chat_messages(@channel_url)
  else
    @chatbot_client.create_channel(@custom_user_id, @channel_name, @channel_url)
    @get_messages = @chatbot_client.chat_messages(@channel_url)
  end
end
end
