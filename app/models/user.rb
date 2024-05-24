class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, :dependent => :destroy
  has_one :cart, :dependent => :destroy
  has_many :addresses, :dependent => :destroy

  accepts_nested_attributes_for :addresses, allow_destroy: true

   # Validate that there is at least one address
   validate :must_have_at_least_one_address
   validates_presence_of :firstname, :lastname

   private

   def must_have_at_least_one_address
     if addresses.reject(&:marked_for_destruction?).empty?
       errors.add(:addresses, "must have at least one address")
     end
   end

end
