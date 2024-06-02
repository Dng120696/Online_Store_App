class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  after_create :send_user_registration
  after_create :send_admin_notification
  has_many :orders, :dependent => :destroy
  has_one :cart, :dependent => :destroy
  has_one :address, :dependent => :destroy
  has_many :shipping_addresses, :dependent => :destroy

  accepts_nested_attributes_for :address, allow_destroy: true

   # Validate that there is at least one address
   validates_presence_of :firstname, :lastname


   def send_user_registration
    if pending?
        UserMailer.new_user_registration(self).deliver_later
    end
  end
  def send_admin_notification
    if pending?
        AdminMailer.new_user_notification(self,Admin.last).deliver_later
    end
  end

   private



end
