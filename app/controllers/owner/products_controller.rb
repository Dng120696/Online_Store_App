class Owner::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_product,only: [:show,:edit,:update,:destroy,:upload_image]
  before_action :categories,only: [:new, :edit, :create, :update]

  def index
    @products = current_admin.products
  end

  def new
    @product = current_admin.products.new
  end

  def edit;end

  def show;end

  def create
    @product = current_admin.products.new(product_params)
    @product.category_ids.reject!(&:blank?)
    if @product.save
      params[:product][:category_ids].each do |category_id|
        unless category_id.blank?
          @product.product_categories.create(category_id: category_id)
        end
      end
      redirect_to owner_products_path, notice: 'Product was successfully created.'
    else
      render :new
    end
  end


  def update
    if @product.update(product_params)
      redirect_to owner_products_path, notice: 'Product was successfully updated.'
    else
      render new_owner_product_path
    end
  end

  def destroy
      @product.destroy
      redirect_to owner_products_path, notice: 'Product was successfully destroyed.'

  end

  def upload_image
    image = params[:image]

    if @product.update(image: image)
      redirect_to owner_products_path
    end

  end
  private

  def categories
    @categories ||= Category.all
  end

  def find_product
    @product = current_admin.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name,:image, :price, :weight, :description, :brand, :inventory_level, :product_type, category_ids: [])
  end

end
