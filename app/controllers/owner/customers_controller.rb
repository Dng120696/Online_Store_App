class Owner::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_user, only: [:update,:show, :edit,:destroy]

  def index
      @users =  User.all
  end
  def edit
   @address = @user.address

  end
  def show; end
  def new
    @user = User.new
    @user.build_address
  end

  def create
    @user = User.new(user_params)
    @user.password = "password123"
    if @user.save
      UserMailer.approved_email(@user).deliver_later
      redirect_to new_owner_customer_address_path(@user)
    else
      render :new
    end

  end
  def update
    if @user.update(user_params)
      redirect_to owner_customers_path, notice: 'User was successfully updated'
    else
      redirect_to edit_owner_customer_path(@user), alert: 'User was not updated'
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
      params.require(:user).permit(:firstname, :lastname, :email, :password,address_attributes:[:id, :street, :city, :country, :zip_code,:state_or_province, :_destroy])
  end

end
