class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: {pending: 0, approved: 1 }
  after_create :send_pending_registration
  after_create :send_admin_approval
  has_many :orders, :dependent => :destroy
  has_one :cart, :dependent => :destroy
  has_one :address, :dependent => :destroy
  has_many :shipping_addresses, :dependent => :destroy

  accepts_nested_attributes_for :address, allow_destroy: true

   # Validate that there is at least one address
   validates_presence_of :firstname, :lastname


   def send_pending_registration
    if pending?
        UserMailer.pending_user_registration(self).deliver_later
    end
  end
  def send_admin_approval
    if pending?
        AdminMailer.new_user_approval(self,Admin.last).deliver_later
    end
  end

   private



end
