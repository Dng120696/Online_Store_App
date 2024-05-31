class Address < ApplicationRecord
  belongs_to :user

  validates_presence_of :zip_code, :street, :city, :state_or_province, :country


end
