class CustomerClient::CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    ActiveRecord::Base.transaction do
    @cart = current_user.cart || Cart.create(user_id: current_user.id)
    @cart_item = @cart.cart_items.find_or_initialize_by(product_id: params[:cart_item][:product_id])
    @cart_item.quantity += params[:cart_item][:quantity].to_i

      if @cart_item.product.inventory_level >= @cart_item.quantity
        if @cart_item.save
            redirect_to customer_client_cart_index_path, notice: 'Product added to cart.'
        else
          redirect_to customer_client_dashboard_index_path, alert: 'Unable to add product to cart.'
        end
      else
        redirect_to customer_client_dashboard_index_path, alert: 'Out of Stock.'
      end
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to customer_client_dashboard_index_path, notice: 'Product removed from cart.'
  end


  def update_quantity
    @cart_item = CartItem.find(params[:cart_item_id])
    cart_item_quantity = params[:cart_item][:quantity].to_i
    if @cart_item.product.inventory_level > cart_item_quantity
      @cart_item.update(quantity: cart_item_quantity)
      redirect_to customer_client_cart_index_path, notice: 'Quantity updated.'
    else
      redirect_to customer_client_cart_index_path, alert: 'Out of Stock.'
    end
  end

end
