class Owner::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :products, only: [:new,:edit,:create,:update]

  def index
    @categories = current_admin.categories
  end

  def show
  end

  def new
    @category = current_admin.categories.new
    @category.products.new
  end

  def create
    @category = current_admin.categories.new(category_params)
    puts "Category Params: #{category_params.inspect}"
    if @category.save
      redirect_to owner_categories_path, notice: "Category was successfully created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to owner_category_path(@category), notice: "Category was succesfully updated"
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to owner_categories_path, notice: "Categories was successfully deleted."
  end

  private

  def set_category
    @category = current_admin.categories.find(params[:id])
  end
  def products
    @products ||= Product.all
  end

  def category_params
    params.require(:category).permit(:title,:description,product_ids: [])
  end
end
