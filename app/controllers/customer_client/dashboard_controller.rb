class CustomerClient::DashboardController < ApplicationController

  def index
    @category = Category.find_by(title: params[:category])
    search_product = params[:search]

    if search_product.present?
      @products = @category.products.where("LOWER(name) LIKE ?", "%#{search_product.downcase}%").includes(image_attachment: :blob).order("inventory_level DESC")
    else

      @products = @category.products.includes(image_attachment: :blob).order("inventory_level DESC")

    end
    @cart = current_user&.cart
    if @cart
      @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob }) # Include product to avoid N+1 queries
    else
      @cart_items = []
    end
  end
  def search_product
      redirect_to customer_client_dashboard_index_path(category:params[:category],search:params[:search])
  end

end
