class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :admin
  has_many :orders, :dependent => :destroy
  has_one :cart, :dependent => :destroy
  has_many :addresses

end
