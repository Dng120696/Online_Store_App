class Owner::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :client
  before_action :find_product,only: [:show,:edit]

  def new
    @product = current_admin.products.new
    @categories = @client.get_all_categories["data"].map { |category| [category['name'], category['id']] }
     p @categories
  end

  def edit;end

  def show;end

  def create
    @categories = @client.get_all_categories["data"].map { |category| [category['name'], category['id']] }

    @product = current_admin.products.new(product_params)
    api_product = create_owner_product(@product)

    if @product.save
      @product.update(api_id: api_product["data"]["id"]) unless api_product.nil?

      redirect_to owner_products_path, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  def index
    @api_products = @client.get_products

    @api_products["data"].each do |product_data|
      product = current_admin.products.find_or_create_by(api_id: product_data["id"]) do |product|
        product.api_id = product_data["id"]
        product.name = product_data["name"]
        product.price = product_data["price"]
        product.description = product_data["description"]
        product.weight = product_data["weight"]
        product.categories = product_data["categories"] || []
        product.brand_id = product_data["brand_id"]
        product.product_type = product_data["type"]
        product.inventory_level = product_data["inventory_level"]
      end
      unless product.persisted?
        puts "Errors: #{product.errors.full_messages.join(', ')}"
      end
    end
    @products = current_admin.products
    # @get_image_of_single_product = @client.get_image_of_single_product(113)
    # render :json => @get_image_of_single_product["data"].first
  end

  private

  def client
    @client ||= BigcommerceAPI::V1::Client.new
  end

  def find_product
    @product = current_admin.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :weight, :description, :brand_id, :inventory_level,:product_typem, categories: [])
  end

  def create_owner_product(product)
    @client.create_product({
        name: product.name,
        price: product.price,
        weight: product.weight,
        categories: product.categories,
        description: product.description,
        brand_id: product.brand_id,
        type: product.product_type,
        inventory_level: product.inventory_level
    })
  end

end
