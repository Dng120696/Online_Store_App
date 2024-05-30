class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, :dependent => :destroy
  has_one :cart, :dependent => :destroy
  has_one :address, :dependent => :destroy
  has_many :shipping_addresses, :dependent => :destroy

  accepts_nested_attributes_for :address, allow_destroy: true

   # Validate that there is at least one address
   validates_presence_of :firstname, :lastname



end
