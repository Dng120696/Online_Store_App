class CustomerClient::DashboardController < ApplicationController

  def index; end

  def load_products
    search_product = params[:search]
    params_category = params[:category]

    if params_category == 'Best Seller'
      @products = Product.where("order_items_count > 1").includes(image_attachment: :blob).order(order_items_count: :desc)
    elsif params_category == 'New Releases'
      @products = Product.where("created_at >= ?", 12.hours.ago).includes(image_attachment: :blob)
    else
    @category = Category.find_by(title: params_category.empty? ? 'Best Seller' : params_category)

      if @category
        @products = if search_product.present?
                      @category.products.where("LOWER(name) LIKE ?", "%#{search_product.downcase}%")
                                      .includes(image_attachment: :blob)
                                      .order(order_items_count: :desc, inventory_level: :desc)
                    else
                      @category.products.includes(image_attachment: :blob)
                                      .order(order_items_count: :desc, inventory_level: :desc)
                    end
      else
        @products = []
      end
    end


    @cart = current_user&.cart
    @cart_items = @cart ? @cart.cart_items.includes(product: { image_attachment: :blob }) : []

    render partial: 'products'
  end
  def search_product
      redirect_to customer_client_dashboard_index_path(category:params[:category],search:params[:search])
  end

end
