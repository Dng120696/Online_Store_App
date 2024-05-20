class Owner::CustomersController < ApplicationController
  before_action :find_user, only: [:update,:show, :edit,:destroy]

  def index
      @users =  current_admin.user
  end
  def edit; end
  def show; end
  def new
    @user = current_admin.user.new
  end

  def create
    @user = current_admin.user.new(user_params)
    if @user.save
      redirect_to owner_customers_path
    else
      render :new
    end

  end
  def update
    if @user.update(user_params)
      redirect_to owner_customers_path
    else
      render :edit
    end
  end
  def destroy
    @user.destroy
    redirect_to owner_customers_path
  end

  private

  def find_user
    @user =  current_admin.user.find(params[:id])
  end

  def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password)
  end

end
