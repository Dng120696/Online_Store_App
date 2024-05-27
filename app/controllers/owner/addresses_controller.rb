class Owner::AddressesController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_customer_address, only: [:edit, :update,:destroy,:show]
  before_action :find_customer, only: [:new, :create]

  def new
    @address = @user.addresses.new
  end

  def create
    @address = @user.addresses.new(address_params)
    if @address.save
      redirect_to owner_customers_path, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  def show

  end
  def edit; end

  def update
    if @address.update(address_params)
      redirect_to owner_customers_path, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @address.destroy
    redirect_to owner_customers_path, notice: 'Address was successfully deleted.'
  end

  private

  def find_customer_address
    @user = User.find(params[:customer_id])
    @address = @user.addresses.find(params[:id])
  end
  def find_customer
    @user = User.find(params[:customer_id])
  end
  def address_params
    params.require(:address).permit(:city,:country,:state_or_province,:zip_code,:email,:street,:address_type)
  end

end
