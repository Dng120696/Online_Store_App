class Owner::CategoriesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = current_admin.categories
  end

  def show
  end

  def new
    @category = current_admin.categories.build
  end

  def create
    @category = current_admin.categories.build(category_params)
    if @category.save
      redirect_to owner_categories_path(@category), notice: "Category was successfully created"
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

  def category_params
    params.require(:category).permit(:title, :admin_id)
  end
end
