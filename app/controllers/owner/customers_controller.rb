class Owner::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_user, only: [:update,:show, :edit,:destroy]

  def index
      @users =  User.all
  end
  def edit
   @addresses = @user.addresses

  end
  def show; end
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_owner_customer_address_path(@user)
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
    @user =  User.find(params[:id])
  end

  def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :password)
  end

end
