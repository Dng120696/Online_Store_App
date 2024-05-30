class ShippingAddress < ApplicationRecord
  belongs_to :user

  validates_presence_of :zip_code, :street, :city, :state_or_province, :country


  def full_address
    "#{user.firstname} #{user.lastname} \n#{street}\n#{city}, #{state_or_province}, #{zip_code}\n#{country}"
  end
end
