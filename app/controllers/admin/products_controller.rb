class Admin::ProductsController < ApplicationController
  def index
    @products = BigcommerceAPI::V1::Client.new
    # @get_products = @products.get_products
    # @create_products = @products.create_product
    # @get_single_product = @products.get_single_product
    # @get_image_of_single_product = @products.get_image_of_single_product
    @create_customer = @products.create_customer

    # render json: @get_products
    # render json: @create_products
    # render json: @get_single_product
    # render json: @get_image_of_single_product
    render json: @create_customer
  end
end
